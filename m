Return-Path: <linux-kernel-owner+w=401wt.eu-S1755420AbYILKAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbYILKAb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 06:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbYILKAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 06:00:21 -0400
Received: from atlas.informatik.uni-freiburg.de ([132.230.150.3]:52216 "EHLO
	atlas.informatik.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752712AbYILKAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 06:00:20 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<ukleinek@informatik.uni-freiburg.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Cc: Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH] MAINTAINERS: Remove a stale entry refering to kernel 2.2
Date: Fri, 12 Sep 2008 12:00:13 +0200
Message-Id: <1221213616-23299-1-git-send-email-ukleinek@informatik.uni-freiburg.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20080912095851.GA3174@informatik.uni-freiburg.de>
References: <20080912095851.GA3174@informatik.uni-freiburg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: Universitaet Freiburg, Institut f. Informatik
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moreover sending an email to twoller@crystal.cirrus.com results in a
"permanent fatal error" (reason: 550 5.0.0
<twoller@crystal.cirrus.com>... Mailbox disabled for this username)

Signed-off-by: Uwe Kleine-König <ukleinek@informatik.uni-freiburg.de>
---
 MAINTAINERS |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 186be3b..dc4107a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1113,8 +1113,6 @@ L:	alsa-devel@alsa-project.org
 S:	Supported
 
 CIRRUS LOGIC CS4280/CS461x SOUNDDRIVER
-P:	Cirrus Logic Corporation (kernel 2.2 driver)
-M:	Cirrus Logic Corporation, Thomas Woller <twoller@crystal.cirrus.com>
 P:	Nils Faerber (port to kernel 2.4)
 M:	Nils Faerber <nils@kernelconcepts.de>
 S:	Maintained
-- 
1.5.6.5

