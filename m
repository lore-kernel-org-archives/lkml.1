Return-Path: <linux-kernel-owner+w=401wt.eu-S1753529AbYANVPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbYANVPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 16:15:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbYANVPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 16:15:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:15807 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbYANVPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 16:15:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=rOBqYYn/oWtQ3cmbwzd47Idqf79xqUTdGxQQ/wqsPpSE/H80sHOtgchbIFK4w0vahryq1BfBB0kdzDL1T4S+QRUDBRtpiZFyvfFhtoTPxytI2OvBNU1ZnRa/8j+3qWBJ2rDykcNK14AkI1YJjSle1R9mpQQGMCopFNWkjYdMsZQ=
Message-ID: <478BD0D2.2060004@gmail.com>
Date: Tue, 15 Jan 2008 00:14:58 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH][MIPS] Add Atlas to feature-removal-schedule.
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ralf Baechle on Atlas board support in the linux-mips mailing list:

Maciej is promising to fix it up since a few years ;-)  Aside of that it's
safe to say the Atlas is dead like a coffin nail.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 Documentation/feature-removal-schedule.txt |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 20c4c8b..c053318 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -333,3 +333,11 @@ Why:	This driver has been marked obsolete for many years.
 Who:	Stephen Hemminger <shemminger@linux-foundation.org>
 
 ---------------------------
+
+What:	Support for MIPS Technologies' Altas evaluation board
+When:	March 2008
+Why:	Apparently there is no user base left for this platform.
+	Hardware out of production since several years.
+Who:	Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
+
+---------------------------
-- 
1.5.3
