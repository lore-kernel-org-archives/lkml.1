Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbXJWJzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbXJWJzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 05:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbXJWJzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 05:55:43 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:53548
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751993AbXJWJzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 05:55:42 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] Add missing IDs to procfs-guide.tmpl
Date: Tue, 23 Oct 2007 04:55:09 -0500
User-Agent: KMail/1.9.6
Cc: akpm@linux-foundation.org, J.A.K.Mouw@its.tudelft.nl
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710230455.09327.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>

Add missing IDs to procfs-guide.tmpl

Signed-off-by: Rob Landley <rob@landley.net>
---

 Documentation/DocBook/procfs-guide.tmpl |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -r a868e8217782 Documentation/DocBook/procfs-guide.tmpl
--- a/Documentation/DocBook/procfs-guide.tmpl	Mon Oct 22 19:40:02 2007 -0700
+++ b/Documentation/DocBook/procfs-guide.tmpl	Mon Oct 22 23:48:57 2007 -0500
@@ -85,7 +85,7 @@
 
 
 
-  <preface>
+  <preface id="Preface">
     <title>Preface</title>
 
     <para>
@@ -230,7 +230,7 @@
 
 
 
-    <sect1>
+    <sect1 id="Creating_a_symlink">
       <title>Creating a symlink</title>
 
       <funcsynopsis>
@@ -254,7 +254,7 @@
       </para>
     </sect1>
 
-    <sect1>
+    <sect1 id="Creating_a_directory">
       <title>Creating a directory</title>
       
       <funcsynopsis>
@@ -274,7 +274,7 @@
 
 
 
-    <sect1>
+    <sect1 id="Removing_an_entry">
       <title>Removing an entry</title>
       
       <funcsynopsis>
@@ -340,7 +340,7 @@ entry->write_proc = write_proc_foo;
 
 
 
-    <sect1>
+    <sect1 id="Reading_data">
       <title>Reading data</title>
 
       <para>
@@ -448,7 +448,7 @@ entry->write_proc = write_proc_foo;
 
 
 
-    <sect1>
+    <sect1 id="Writing_data">
       <title>Writing data</title>
 
       <para>
@@ -579,7 +579,7 @@ int foo_read_func(char *page, char **sta
 
 
 
-    <sect1>
+    <sect1 id="Modules">
       <title>Modules</title>
 
       <para>
@@ -599,7 +599,7 @@ entry->owner = THIS_MODULE;
 
 
 
-    <sect1>
+    <sect1 id="Mode_and_ownership">
       <title>Mode and ownership</title>
 
       <para>

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
