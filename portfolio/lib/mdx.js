import fs from 'fs';
import path from 'path';
import matter from 'gray-matter';

const contentDirectory = path.join(process.cwd(), 'content');

export function getAllPosts() {
  const filenames = fs.readdirSync(contentDirectory);
  
  return filenames.map((filename) => {
    const filePath = path.join(contentDirectory, filename);
    const fileContents = fs.readFileSync(filePath, 'utf8');
    const { data, content } = matter(fileContents);
    
    return {
      slug: filename.replace(/\.mdx$/, ''),
      frontmatter: data,
      content,
    };
  }).sort((post1, post2) => {
    return new Date(post2.frontmatter.date) - new Date(post1.frontmatter.date);
  });
}

export function getPostBySlug(slug) {
  const filePath = path.join(contentDirectory, `${slug}.mdx`);
  const fileContents = fs.readFileSync(filePath, 'utf8');
  const { data, content } = matter(fileContents);
  
  return {
    slug,
    frontmatter: data,
    content,
  };
}
