Return-Path: <linux-kernel-owner+w=401wt.eu-S1753402AbYIMU3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbYIMU3o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 16:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbYIMU3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 16:29:36 -0400
Received: from atlas.informatik.uni-freiburg.de ([132.230.150.3]:60602 "EHLO
	atlas.informatik.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752004AbYIMU3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 16:29:35 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<ukleinek@informatik.uni-freiburg.de>
To: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] =?utf-8?q?Add=20Uwe=20Kleine-K=C3=B6nig=20to=20.mailmap?=
Date: Sat, 13 Sep 2008 22:29:31 +0200
Message-Id: <1221337771-31332-1-git-send-email-ukleinek@informatik.uni-freiburg.de>
X-Mailer: git-send-email 1.5.6.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: Universitaet Freiburg, Institut f. Informatik
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a few commits that misencoded my name (or used "oe" instead of
"ö").  So add a correct version to .mailmap.

Signed-off-by: Uwe Kleine-König <ukleinek@informatik.uni-freiburg.de>
---
 .mailmap |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/.mailmap b/.mailmap
index 7260842..dfab12f 100644
--- a/.mailmap
+++ b/.mailmap
@@ -96,4 +96,6 @@ Tejun Heo <htejun@gmail.com>
 Thomas Graf <tgraf@suug.ch>
 Tony Luck <tony.luck@intel.com>
 Tsuneo Yoshioka <Tsuneo.Yoshioka@f-secure.com>
+Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
+Uwe Kleine-König <ukleinek@informatik.uni-freiburg.de>
 Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
-- 
1.5.6.5

