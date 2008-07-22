Return-Path: <linux-kernel-owner+w=401wt.eu-S1754552AbYGVTYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbYGVTYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:24:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbYGVTXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:23:51 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:24944 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbYGVTXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:23:50 -0400
X-BigFish: VPS22(zzzz10d3izzz32i87il64h)
X-Spam-TCS-SCL: 3:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K4F9V7-02-3LM-01
From: Robert Richter <robert.richter@amd.com>
To: Barry Kasindorf <barry.kasindorf@amd.com>, Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/24] oprofile: Add IBS support for AMD CPUs
Date: Tue, 22 Jul 2008 21:08:44 +0200
Message-ID: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
X-OriginalArrivalTime: 22 Jul 2008 19:23:38.0792 (UTC) FILETIME=[71903280:01C8EC30]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches #1-3 are not directly related to IBS.
Patch #4 adds generic support of model specific initialization.
Patches #10, #11 add the core implementation of IBS.
Patches #12-24 contain code improvements and small fixes.



