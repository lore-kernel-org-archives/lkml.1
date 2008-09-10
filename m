Return-Path: <linux-kernel-owner+w=401wt.eu-S1755646AbYIJTwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646AbYIJTwz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 15:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbYIJTvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 15:51:51 -0400
Received: from atlas.informatik.uni-freiburg.de ([132.230.150.3]:40388 "EHLO
	atlas.informatik.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752360AbYIJTvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 15:51:50 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<ukleinek@informatik.uni-freiburg.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: put corresponding realnames and mail addresses together
Date: Wed, 10 Sep 2008 21:51:38 +0200
Message-Id: <1221076300-7018-4-git-send-email-ukleinek@informatik.uni-freiburg.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1221076300-7018-3-git-send-email-ukleinek@informatik.uni-freiburg.de>
References: <20080910193210.GA26173@informatik.uni-freiburg.de>
 <1221076300-7018-1-git-send-email-ukleinek@informatik.uni-freiburg.de>
 <1221076300-7018-2-git-send-email-ukleinek@informatik.uni-freiburg.de>
 <1221076300-7018-3-git-send-email-ukleinek@informatik.uni-freiburg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: Universitaet Freiburg, Institut f. Informatik
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... otherwise my script to merge P and M fields has not chance to do its
job.

Signed-off-by: Uwe Kleine-König <ukleinek@informatik.uni-freiburg.de>
---
 MAINTAINERS |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 19fa2d5..5ad6e50 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1510,8 +1510,8 @@ S:	Supported
 
 EDAC-E752X
 P:	Mark Gross
-P:	Doug Thompson
 M:	mark.gross@intel.com
+P:	Doug Thompson
 M:	dougthompson@xmission.com
 L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
@@ -1547,8 +1547,8 @@ S:	Maintained
 
 EDAC-I82975X
 P:	Ranganathan Desikan
-P:	Arvind R.
 M:	rdesikan@jetzbroadband.com
+P:	Arvind R.
 M:	arvind@acarlab.com
 L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
-- 
1.5.6.5

