Return-Path: <linux-kernel-owner+w=401wt.eu-S1755892AbYILKAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbYILKAn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 06:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbYILKAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 06:00:22 -0400
Received: from atlas.informatik.uni-freiburg.de ([132.230.150.3]:52220 "EHLO
	atlas.informatik.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752712AbYILKAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 06:00:21 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<ukleinek@informatik.uni-freiburg.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Cc: Paul Bolle <pebolle@tiscali.nl>, Andreas Dilger <adilger@sun.com>
Subject: [PATCH] MAINTAINERS: add a realname for adilger@sun.com
Date: Fri, 12 Sep 2008 12:00:14 +0200
Message-Id: <1221213616-23299-2-git-send-email-ukleinek@informatik.uni-freiburg.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1221213616-23299-1-git-send-email-ukleinek@informatik.uni-freiburg.de>
References: <20080912095851.GA3174@informatik.uni-freiburg.de>
 <1221213616-23299-1-git-send-email-ukleinek@informatik.uni-freiburg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: Universitaet Freiburg, Institut f. Informatik
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without it my script to merge the P and M fields fails to assign the two
realnames to the three email addresses.

Signed-off-by: Uwe Kleine-König <ukleinek@informatik.uni-freiburg.de>
Cc: Andreas Dilger <adilger@sun.com>
---
 MAINTAINERS |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index dc4107a..cd46667 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1633,13 +1633,13 @@ L:	linux-ext4@vger.kernel.org
 S:	Maintained
 
 EXT3 FILE SYSTEM
-P:	Stephen Tweedie, Andrew Morton
+P:	Stephen Tweedie, Andrew Morton, Andreas Dilger
 M:	sct@redhat.com, akpm@linux-foundation.org, adilger@sun.com
 L:	linux-ext4@vger.kernel.org
 S:	Maintained
 
 EXT4 FILE SYSTEM
-P:	Stephen Tweedie, Andrew Morton
+P:	Stephen Tweedie, Andrew Morton, Andreas Dilger
 M:	sct@redhat.com, akpm@linux-foundation.org, adilger@sun.com
 L:	linux-ext4@vger.kernel.org
 S:	Maintained
-- 
1.5.6.5

