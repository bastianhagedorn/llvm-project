// RUN: mlir-tblgen --print-records -I %S/../../include %s | FileCheck %s

// Verifies that template parameters of vector-shape type constraints in
// CommonTypeConstraints.td are exposed as queryable Record fields, so
// mlir-tblgen backends can introspect values like allowedTypes,
// allowedLengths, allowedRanks, minLength, maxLength, shape, and elType
// structurally instead of parsing the summary string.

include "mlir/IR/CommonTypeConstraints.td"

def TestVecLengthAndType  : VectorOfLengthAndType<[2, 4], [I32, F32]>;
def TestVecRankLengthType : VectorOfRankAndLengthAndType<[1, 2], [4, 8], [F16]>;
def TestVecMinMax         : VectorOfMinMaxLengthAndType<2, 16, [I64]>;
def TestVecShape          : FixedVectorOfShapeAndType<[2, 3], F32>;

// CHECK-LABEL: def TestVecLengthAndType
// CHECK-DAG:   list<Type> allowedTypes = [I32, F32];
// CHECK-DAG:   list<int> allowedLengths = [2, 4];

// CHECK-LABEL: def TestVecMinMax
// CHECK-DAG:   list<Type> allowedTypes = [I64];
// CHECK-DAG:   int minLength = 2;
// CHECK-DAG:   int maxLength = 16;

// CHECK-LABEL: def TestVecRankLengthType
// CHECK-DAG:   list<Type> allowedTypes = [F16];
// CHECK-DAG:   list<int> allowedRanks = [1, 2];
// CHECK-DAG:   list<int> allowedLengths = [4, 8];

// CHECK-LABEL: def TestVecShape
// CHECK-DAG:   list<Type> allowedTypes = [F32];
// CHECK-DAG:   list<int> shape = [2, 3];
// CHECK-DAG:   Type elType = F32;
