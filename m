Return-Path: <linux-kernel-owner+w=401wt.eu-S1761947AbYJJVUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761947AbYJJVUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 17:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759624AbYJJVT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 17:19:58 -0400
Received: from smtp6-g19.free.fr ([212.27.42.36]:41478 "EHLO smtp6-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759539AbYJJVT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 17:19:57 -0400
Date: Fri, 10 Oct 2008 23:19:48 +0200
From: FD Cami <francois.cami@free.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Alex Howells <alex@bytemark.co.uk>,
       Nick Warne <nick@ukfsn.org>, trivial@kernel.org,
       linux-kernel@vger.kernel.org, Li Yang <leoli@freescale.com>,
       minchan Kim <minchan.kim@gmail.com>,
       Tsugikazu Shibata <tshibata@ab.jp.nec.com>
Subject: [PATCH] Remove Andrew Morton's http://www.zip.com.au/~akpm/
Message-ID: <20081010231948.0ed198d5@moria>
In-Reply-To: <20081010111031.9518a142.akpm@linux-foundation.org>
References: <20081010151539.6a2ff040@sauron.linicks.net>
	<48EF6B47.1080800@bytemark.co.uk>
	<20081010093427.31ddb955.randy.dunlap@oracle.com>
	<20081010192600.547eedcc@moria>
	<20081010111031.9518a142.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2008 11:10:31 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 10 Oct 2008 19:26:00 +0200 FD Cami <francois.cami@free.fr> wrote:
> 
> > On Fri, 10 Oct 2008 09:34:27 -0700
> > Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > 
> > > On Fri, 10 Oct 2008 15:48:39 +0100 Alex Howells wrote:
> > > 
> > > > Nick Warne wrote:
> > > > > Andrews' URL seems to be AWOL
> > > > > 
> > > > Perhaps time to update the URLs generally?
> > > 
> > > Would one of you send a patch, please?
> 
> My zip account died for some reason.

Remove Andrew Morton's http://www.zip.com.au/~akpm/ urls, update to new
ones when necessary, delete references otherwise.

There are still instances of that living in :
Documentation/zh_CN/HOWTO
Documentation/zh_CN/SubmittingPatches
Documentation/ko_KR/HOWTO
Documentation/ja_JP/SubmittingPatches
Relevant maintainers CC'ed.

Signed-off-by: Francois Cami <francois.cami@free.fr>


diff -uprN -X linux-2.6.27/Documentation/dontdiff linux-2.6.27/Documentation/filesystems/ext3.txt linux-2.6.27-mine/Documentation/filesystems/ext3.txt
--- linux-2.6.27/Documentation/filesystems/ext3.txt	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27-mine/Documentation/filesystems/ext3.txt	2008-10-10 23:07:39.000000000 +0200
@@ -193,6 +193,5 @@ kernel source:	<file:fs/ext3/>
 programs: 	http://e2fsprogs.sourceforge.net/
 		http://ext2resize.sourceforge.net
 
-useful links:	http://www.zip.com.au/~akpm/linux/ext3/ext3-usage.html
-		http://www-106.ibm.com/developerworks/linux/library/l-fs7/
+useful links:	http://www-106.ibm.com/developerworks/linux/library/l-fs7/
 		http://www-106.ibm.com/developerworks/linux/library/l-fs8/
diff -uprN -X linux-2.6.27/Documentation/dontdiff linux-2.6.27/Documentation/HOWTO linux-2.6.27-mine/Documentation/HOWTO
--- linux-2.6.27/Documentation/HOWTO	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27-mine/Documentation/HOWTO	2008-10-10 23:03:30.000000000 +0200
@@ -112,7 +112,7 @@ required reading:
 
     Other excellent descriptions of how to create patches properly are:
 	"The Perfect Patch"
-		http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt
+		http://userweb.kernel.org/~akpm/stuff/tpp.txt
 	"Linux kernel patch submission format"
 		http://linux.yyz.us/patch-format.html
 
@@ -620,7 +620,7 @@ all time.  It should describe the patch 
 For more details on what this should all look like, please see the
 ChangeLog section of the document:
   "The Perfect Patch"
-      http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt
+      http://userweb.kernel.org/~akpm/stuff/tpp.txt
 
 
 
diff -uprN -X linux-2.6.27/Documentation/dontdiff linux-2.6.27/Documentation/networking/vortex.txt linux-2.6.27-mine/Documentation/networking/vortex.txt
--- linux-2.6.27/Documentation/networking/vortex.txt	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27-mine/Documentation/networking/vortex.txt	2008-10-10 23:11:08.000000000 +0200
@@ -305,11 +305,6 @@ Donald's wake-on-LAN page:
 
 	ftp://ftp.3com.com/pub/nic/3c90x/3c90xx2.exe
 
-Driver updates and a detailed changelog for the modifications which
-were made for the 2.3/2,4 series kernel is available at
-
-     http://www.zip.com.au/~akpm/linux/#3c59x-bc
-
 
 Autonegotiation notes
 ---------------------
diff -uprN -X linux-2.6.27/Documentation/dontdiff linux-2.6.27/Documentation/SubmittingPatches linux-2.6.27-mine/Documentation/SubmittingPatches
--- linux-2.6.27/Documentation/SubmittingPatches	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27-mine/Documentation/SubmittingPatches	2008-10-10 23:06:20.000000000 +0200
@@ -77,7 +77,7 @@ Quilt:
 http://savannah.nongnu.org/projects/quilt
 
 Andrew Morton's patch scripts:
-http://www.zip.com.au/~akpm/linux/patches/
+http://userweb.kernel.org/~akpm/stuff/patch-scripts.tar.gz
 Instead of these scripts, quilt is the recommended patch management
 tool (see above).
 
@@ -653,7 +653,7 @@ SECTION 3 - REFERENCES
 ----------------------
 
 Andrew Morton, "The perfect patch" (tpp).
-  <http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt>
+  <http://userweb.kernel.org/~akpm/stuff/tpp.txt>
 
 Jeff Garzik, "Linux kernel patch submission format".
   <http://linux.yyz.us/patch-format.html>
