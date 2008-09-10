Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbYIJTwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbYIJTwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 15:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbYIJTvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 15:51:48 -0400
Received: from atlas.informatik.uni-freiburg.de ([132.230.150.3]:40382 "EHLO
	atlas.informatik.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752187AbYIJTvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 15:51:47 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<ukleinek@informatik.uni-freiburg.de>
To: linux-kernel@vger.kernel.org
Cc: Thomas Woller <twoller@crystal.cirrus.com>,
       Nils Faerber <nils@kernelconcepts.de>
Subject: [PATCH] Reformat MAINTAINERS entry for Cirrus CS4280/CS461X sound driver
Date: Wed, 10 Sep 2008 21:51:35 +0200
Message-Id: <1221076300-7018-1-git-send-email-ukleinek@informatik.uni-freiburg.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20080910193210.GA26173@informatik.uni-freiburg.de>
References: <20080910193210.GA26173@informatik.uni-freiburg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: Universitaet Freiburg, Institut f. Informatik
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

replace the (anyhow obvious) company name by Thomas' realname and remove
Nils' realname from his M field which is already in the corresponding P
field.

The old entry broke my script to merge the P and M fields.

Signed-off-by: Uwe Kleine-König <ukleinek@informatik.uni-freiburg.de>
Cc: Thomas Woller <twoller@crystal.cirrus.com>
Cc: Nils Faerber <nils@kernelconcepts.de>
---
 MAINTAINERS |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 186be3b..fdea0d3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1113,10 +1113,10 @@ L:	alsa-devel@alsa-project.org
 S:	Supported
 
 CIRRUS LOGIC CS4280/CS461x SOUNDDRIVER
-P:	Cirrus Logic Corporation (kernel 2.2 driver)
-M:	Cirrus Logic Corporation, Thomas Woller <twoller@crystal.cirrus.com>
+P:	Thomas Woller (kernel 2.2 driver)
+M:	twoller@crystal.cirrus.com
 P:	Nils Faerber (port to kernel 2.4)
-M:	Nils Faerber <nils@kernelconcepts.de>
+M:	nils@kernelconcepts.de
 S:	Maintained
 
 CODA FILE SYSTEM
-- 
1.5.6.5

