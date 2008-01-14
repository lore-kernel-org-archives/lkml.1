Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbYANXZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbYANXZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 18:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbYANXZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 18:25:05 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:61849 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712AbYANXZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 18:25:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=Mo071wRkXbBFpybYmco+4WR7qO0MpwD0T2lD2cu/a/3Af82I6pT7hKklVNJ1LdOeIWz8kXo0ibdf83BTlRN6KyGqibHfvQHADJPBZpXI5wXAhAmbGPbCOINmEyqlqCokMC/SNn8Nf31pWwbHMCcJwQAtvDMG+Cyz23SMvycO1MI=
Message-ID: <478BEF4A.80805@gmail.com>
Date: Tue, 15 Jan 2008 02:24:58 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH -v2][MIPS] Add Atlas to feature-removal-schedule.txt
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ralf Baechle on Atlas board support in the linux-mips mailing list:

> Maciej is promising to fix it up since a few years ;-)  Aside of that it's
> safe to say the Atlas is dead like a coffin nail.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>

---
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 20c4c8b..2693ebc 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -333,3 +333,11 @@ Why:	This driver has been marked obsolet
 Who:	Stephen Hemminger <shemminger@linux-foundation.org>
 
 ---------------------------
+
+What:	Support for MIPS Technologies' Atlas evaluation board
+When:	March 2008
+Why:	Apparently there is no user base left for this platform.
+	Hardware out of production since several years.
+Who:	Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
+
+---------------------------
