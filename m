Return-Path: <linux-kernel-owner+w=401wt.eu-S1754506AbYJLT6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbYJLT6X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 15:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbYJLT6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 15:58:15 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:3147 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbYJLT6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 15:58:14 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Mark Brown <broonie@sirena.org.uk>
Date: Sun, 12 Oct 2008 20:56:24 +0100
Message-Id: <1223841384-10449-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] mailmap: Add Mark Brown
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of commits have a broken real name - fix them up.

Signed-off-by: Mark Brown <broonie@sirena.org.uk>
---
 .mailmap |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/.mailmap b/.mailmap
index dfab12f..eba9bf9 100644
--- a/.mailmap
+++ b/.mailmap
@@ -66,6 +66,7 @@ Kenneth W Chen <kenneth.w.chen@intel.com>
 Koushik <raghavendra.koushik@neterion.com>
 Leonid I Ananiev <leonid.i.ananiev@intel.com>
 Linas Vepstas <linas@austin.ibm.com>
+Mark Brown <broonie@sirena.org.uk>
 Matthieu CASTET <castet.matthieu@free.fr>
 Michael Buesch <mb@bu3sch.de>
 Michael Buesch <mbuesch@freenet.de>
-- 
1.5.4.3

