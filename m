Return-Path: <linux-kernel-owner+w=401wt.eu-S1762949AbXHaAQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762949AbXHaAQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 20:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758417AbXHaAQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 20:16:14 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:45507
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757044AbXHaAQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 20:16:13 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] Documentation/00-INDEX notice ecryptfs.txt moved.
Date: Thu, 30 Aug 2007 20:16:12 -0500
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>
References: <200708301446.18024.rob@landley.net> <20070830120437.6fe49cdc.randy.dunlap@oracle.com>
In-Reply-To: <20070830120437.6fe49cdc.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708302016.12133.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 August 2007 2:04:37 pm Randy Dunlap wrote:
> Please use the expected (canonical) patch format.
>
> See Documentation/SubmittingPatches:
>   14) The canonical patch format

from Rob Landley <rob@landley.net>
Signed-off-by: Rob Landley <rob@landley.net>

ecryptfs.txt moved into filesystems, make 00-INDEX follow.

---

 00-INDEX             |    2 --
 filesystems/00-INDEX |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.23-rc4/Documentation/00-INDEX	2007-08-27 20:32:35.000000000 -0500
+++ linux-new/Documentation/00-INDEX	2007-08-30 14:43:15.000000000 -0500
@@ -134,8 +134,6 @@
 	- info on Linux Digital Video Broadcast (DVB) subsystem.
 early-userspace/
 	- info about initramfs, klibc, and userspace early during boot.
-ecryptfs.txt
-	- docs on eCryptfs: stacked cryptographic filesystem for Linux.
 eisa.txt
 	- info on EISA bus support.
 exception.txt
--- linux-2.6.23-rc4/Documentation/filesystems/00-INDEX	2007-08-27 20:32:35.000000000 -0500
+++ linux-new/Documentation/filesystems/00-INDEX	2007-08-30 14:42:08.000000000 -0500
@@ -32,6 +32,8 @@
 	- info about the locking scheme used for directory operations.
 dlmfs.txt
 	- info on the userspace interface to the OCFS2 DLM.
+ecryptfs.txt
+	- docs on eCryptfs: stacked cryptographic filesystem for Linux.
 ext2.txt
 	- info, mount options and specifications for the Ext2 filesystem.
 ext3.txt
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
