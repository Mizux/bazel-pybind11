#include "foobar/FooBar.hpp"

#include <gtest/gtest.h>

#include <iostream>
#include <numeric>
#include <string>

namespace foobar {
TEST(FooBarTest, FreeFunction) {
  EXPECT_NO_THROW(freeFunction(42));
  EXPECT_NO_THROW(freeFunction(int64_t{42}));
}

TEST(FooBarTest, StringVectorOutput) {
  std::vector<std::string> result;
  ASSERT_NO_THROW(result = stringVectorOutput(8));
  EXPECT_EQ(result.size(), 18);
  for (const auto& it : result) {
    EXPECT_EQ(it, std::to_string(9));
  }
}

TEST(FooBarTest, StringVectorValueInput) {
  const std::vector<std::string> data{"1", "2", "3", "4", "5"};
  int                            size = 0;
  ASSERT_NO_THROW(size = stringVectorInput(data));
  EXPECT_EQ(size, 5);
}

TEST(FooBarTest, StringVectorRefInput) {
  const std::vector<std::string> data{"1", "2", "3", "4", "5"};
  int                            size = 0;
  ASSERT_NO_THROW(size = stringVectorRefInput(data));
  EXPECT_EQ(size, 5);
}

TEST(FooBarTest, StringJaggedArrayOutput) {
  std::vector<std::vector<std::string>> result;
  ASSERT_NO_THROW(result = stringJaggedArrayOutput(8));
  EXPECT_EQ(result.size(), 8);
  for (std::size_t i = 0; i < result.size(); ++i) {
    EXPECT_EQ(i + 1, result[i].size());
  }
  for (std::size_t i = 1; i <= result.size(); ++i) {
    const auto& inner = result[i - 1];
    for (const auto& it : inner) {
      EXPECT_EQ(it, std::to_string(i));
    }
  }
}

TEST(FooBarTest, StringJaggedArrayValueInput) {
  const std::vector<std::vector<std::string>> data{{"1", "2", "3"}, {"4", "5"}};
  int                                         size = 0;
  ASSERT_NO_THROW(size = stringJaggedArrayInput(data));
  EXPECT_EQ(size, 2);
}

TEST(FooBarTest, StringJaggedArrayRefInput) {
  const std::vector<std::vector<std::string>> data{{"1", "2", "3"}, {"4", "5"}};
  int                                         size = 0;
  ASSERT_NO_THROW(size = stringJaggedArrayRefInput(data));
  EXPECT_EQ(size, 2);
}

TEST(FooBarTest, PairVectorOutput) {
  std::vector<std::pair<int, int>> result;
  ASSERT_NO_THROW(result = pairVectorOutput(8));
  EXPECT_EQ(result.size(), 18);
  for (const auto& it : result) {
    EXPECT_EQ(it.first, 9);
    EXPECT_EQ(it.second, 9);
  }
}

TEST(FooBarTest, PairVectorValueInput) {
  const std::vector<std::pair<int, int>> data{{1, 2}, {3, 4}, {5, 6}};
  int                                    size = 0;
  ASSERT_NO_THROW(size = pairVectorInput(data));
  EXPECT_EQ(size, 3);
}

TEST(FooBarTest, PairVectorRefInput) {
  const std::vector<std::pair<int, int>> data{{1, 2}, {3, 4}, {5, 6}};
  int                                    size = 0;
  ASSERT_NO_THROW(size = pairVectorRefInput(data));
  EXPECT_EQ(size, 3);
}

TEST(FooBarTest, PairJaggedArrayOutput) {
  std::vector<std::vector<std::pair<int, int>>> result;
  ASSERT_NO_THROW(result = pairJaggedArrayOutput(8));
  EXPECT_EQ(result.size(), 8);
  for (std::size_t i = 0; i < result.size(); ++i) {
    EXPECT_EQ(i + 1, result[i].size());
  }
  for (int i = 1; i <= static_cast<int>(result.size()); ++i) {
    const auto& inner = result[i - 1];
    for (const auto& it : inner) {
      EXPECT_EQ(it.first, i);
      EXPECT_EQ(it.second, i);
    }
  }
}

TEST(FooBarTest, PairJaggedArrayValueInput) {
  std::vector<std::vector<std::pair<int, int>>> data{{{1, 1}, {2, 2}, {3, 3}}, {{4, 4}, {5, 5}}};
  int                                           size = 0;
  ASSERT_NO_THROW(size = pairJaggedArrayInput(data));
  EXPECT_EQ(size, 2);
}

TEST(FooBarTest, PairJaggedArrayRefInput) {
  std::vector<std::vector<std::pair<int, int>>> data{{{1, 1}, {2, 2}, {3, 3}}, {{4, 4}, {5, 5}}};
  int                                           size = 0;
  ASSERT_NO_THROW(size = pairJaggedArrayRefInput(data));
  EXPECT_EQ(size, 2);
}

TEST(FooBarTest, StaticMethods) {
  EXPECT_NO_THROW(FooBar::staticFunction(42));
  EXPECT_NO_THROW(FooBar::staticFunction(int64_t{42}));
}

TEST(FooBarTest, Constructor) {
  FooBar* fb = new FooBar();
  EXPECT_NE(fb, nullptr);
}

TEST(FooBarTest, IntMethods) {
  FooBar foobar;
  ASSERT_NO_THROW(foobar.setBarInt(31));
  ASSERT_NO_THROW(foobar.setFooInt(42));
  EXPECT_EQ(foobar.getInt(), 73);
}

TEST(FooBarTest, Int64Methods) {
  FooBar foobar;
  ASSERT_NO_THROW(foobar.setBarInt64(13));
  ASSERT_NO_THROW(foobar.setFooInt64(17));
  EXPECT_EQ(foobar.getInt64(), 30);
}

TEST(FooBarTest, PrintMethod) {
  FooBar      foobar;
  std::string str("");
  ASSERT_NO_THROW(str = foobar());
  EXPECT_EQ(
      "\"FooBar\":{\"Bar\":{\"int\":0,\"int64\":0},\"Foo\":{\"int\":0,\"int64\":0}}",
      str);
}

} // namespace foobar
