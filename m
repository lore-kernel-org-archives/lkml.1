Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646AbYIYKOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbYIYKOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 06:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbYIYKOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 06:14:21 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:4574 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbYIYKOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 06:14:19 -0400
X-BigFish: VPS3(zzzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K7QXR8-03-FWE-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
CC: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 0/3] some small GART cleanups
Date: Thu, 25 Sep 2008 12:13:52 +0200
Message-ID: <1222337635-28285-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
X-OriginalArrivalTime: 25 Sep 2008 10:13:55.0502 (UTC) FILETIME=[6AD74CE0:01C91EF7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this small patch series contains some cleanups for the K8 GART driver in
the x86 architecture.

diffstat:

 arch/x86/kernel/pci-gart_64.c |   38 ++++++++++++++++++--------------------
 include/asm-x86/gart.h        |    2 ++
 2 files changed, 20 insertions(+), 20 deletions(-)



