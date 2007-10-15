Return-Path: <linux-kernel-owner+w=401wt.eu-S1763652AbXJOMQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763652AbXJOMQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 08:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758651AbXJOMQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 08:16:26 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:6813 "EHLO
	outbound1-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755700AbXJOMQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 08:16:25 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2 try#4] x86: MCE optimization and cleanups
Date: Mon, 15 Oct 2007 14:16:11 +0200
Message-ID: <11924505733872-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.2.5
X-OriginalArrivalTime: 15 Oct 2007 12:16:13.0983 (UTC)
 FILETIME=[2DFD22F0:01C80F25]
MIME-Version: 1.0
X-WSS-ID: 6B0D859B0601848593-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset includes two patches.

1. Checks for the MCA fetures as early as possible and signedness fixup.
2. Minor coding style cleanup.




