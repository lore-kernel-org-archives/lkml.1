Return-Path: <linux-kernel-owner+w=401wt.eu-S1752914AbYL2Qhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbYL2Qhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 11:37:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbYL2Qhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 11:37:32 -0500
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:54772 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbYL2Qhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 11:37:31 -0500
Message-ID: <4958FCBA.40200@freemail.hu>
Date: Mon, 29 Dec 2008 17:37:14 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>, video4linux-list@redhat.com
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] modify V4L documentation to be a valid XHTML
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail02d.mail.t-online.hu 32710; Body=3 Fuz1=3
	Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify Documentation/video4linux/API.html to be a valid XHTML 1.0 Strict.
The result was verified using the http://validator.w3.org/ service.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
--- linux-2.6.28/Documentation/video4linux/API.html.orig	2008-06-12 07:31:57.000000000 +0200
+++ linux-2.6.28/Documentation/video4linux/API.html	2008-12-29 17:26:45.000000000 +0100
@@ -1,16 +1,27 @@
-<TITLE>V4L API</TITLE>
-<H1>Video For Linux APIs</H1>
-<table border=0>
-<tr>
-<td>
-<A HREF=http://www.linuxtv.org/downloads/video4linux/API/V4L1_API.html>
-V4L original API</a>
-</td><td>
-Obsoleted by V4L2 API
-</td></tr><tr><td>
-<A HREF=http://www.linuxtv.org/downloads/video4linux/API/V4L2_API>
-V4L2 API</a>
-</td><td>
-Should be used for new projects
-</td></tr>
-</table>
+<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
+<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
+ <head>
+  <meta content="text/html;charset=ISO-8859-2" http-equiv="Content-Type" />
+  <title>V4L API</title>
+ </head>
+ <body>
+  <h1>Video For Linux APIs</h1>
+  <table border="0">
+   <tr>
+    <td>
+     <a href="http://www.linuxtv.org/downloads/video4linux/API/V4L1_API.html">V4L original API</a>
+    </td>
+    <td>
+     Obsoleted by V4L2 API
+    </td>
+   </tr>
+   <tr>
+    <td>
+     <a href="http://www.linuxtv.org/downloads/video4linux/API/V4L2_API">V4L2 API</a>
+    </td>
+    <td>Should be used for new projects
+    </td>
+   </tr>
+  </table>
+ </body>
+</html>
