Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858AbYIJTv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbYIJTv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 15:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbYIJTvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 15:51:48 -0400
Received: from atlas.informatik.uni-freiburg.de ([132.230.150.3]:40385 "EHLO
	atlas.informatik.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752145AbYIJTvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 15:51:47 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<ukleinek@informatik.uni-freiburg.de>
To: linux-kernel@vger.kernel.org
Cc: Andreas Dilger <adilger@sun.com>
Subject: [PATCH] MAINTAINERS: add a realname for adilger@sun.com
Date: Wed, 10 Sep 2008 21:51:36 +0200
Message-Id: <1221076300-7018-2-git-send-email-ukleinek@informatik.uni-freiburg.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1221076300-7018-1-git-send-email-ukleinek@informatik.uni-freiburg.de>
References: <20080910193210.GA26173@informatik.uni-freiburg.de>
 <1221076300-7018-1-git-send-email-ukleinek@informatik.uni-freiburg.de>
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
index fdea0d3..6b2ea6e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1635,13 +1635,13 @@ L:	linux-ext4@vger.kernel.org
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

