Return-Path: <linux-kernel-owner+w=401wt.eu-S1757508AbYLEKVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508AbYLEKVu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 05:21:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbYLEKUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 05:20:52 -0500
Received: from vps1.tull.net ([66.180.172.116]:47093 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751789AbYLEKUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 05:20:50 -0500
Mail-From: nobody Fri Dec  5 14:07:58 2008
From: Nick Andrew <nick@nick-andrew.net>
Subject: [PATCH] Fix incorrect use of loose in hfs.txt
To: Nick Andrew <nick@nick-andrew.net>, Roman Zippel <zippel@linux-m68k.org>,
       linux-kernel@vger.kernel.org
Cc: <linux-kernel@vger.kernel.org>, Nick Andrew <nick@nick-andrew.net>
Date: Fri, 05 Dec 2008 14:07:58 +1100
Message-ID: <20081205030758.31888.30272.stgit@marcab.local.tull.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix incorrect use of loose in hfs.txt

It should be 'lose', not 'loose'.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 Documentation/filesystems/hfs.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/Documentation/filesystems/hfs.txt b/Documentation/filesystems/hfs.txt
index bd0fa77..28f0225 100644
--- a/Documentation/filesystems/hfs.txt
+++ b/Documentation/filesystems/hfs.txt
@@ -61,7 +61,7 @@ the a little strange:
    Finder's metadata.
  o They are however created (with default values), deleted and renamed
    along with the corresponding data fork or directory.
- o Copying files to a different filesystem will loose those attributes
+ o Copying files to a different filesystem will lose those attributes
    that are essential for MacOS to work.
 
 


