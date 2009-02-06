Return-Path: <linux-kernel-owner+w=401wt.eu-S1755089AbZBFNxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbZBFNxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 08:53:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757380AbZBFNxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 08:53:24 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47665 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757369AbZBFNxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 08:53:23 -0500
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] Add Sascha Hauer to .mailmap
Date: Fri,  6 Feb 2009 14:53:18 +0100
Message-Id: <1233928399-22012-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.5.6.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the shortlog attribution e.g. for 106757b38fff

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
---
Hello,

I'm not sure where these .mailmap changes should go to.  I think Linus
directly?

Best regards
Uwe

 .mailmap |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/.mailmap b/.mailmap
index 4e83e7b..aa934d1 100644
--- a/.mailmap
+++ b/.mailmap
@@ -92,6 +92,7 @@ Rudolf Marek <R.Marek@sh.cvut.cz>
 Rui Saraiva <rmps@joel.ist.utl.pt>
 Sachin P Sant <ssant@in.ibm.com>
 Sam Ravnborg <sam@mars.ravnborg.org>
+Sascha Hauer <s.hauer@pengutronix.de>
 S.Çağlar Onur <caglar@pardus.org.tr>
 Simon Kelley <simon@thekelleys.org.uk>
 Stéphane Witzmann <stephane.witzmann@ubpmes.univ-bpclermont.fr>
-- 
1.5.6.5

