Return-Path: <linux-kernel-owner+w=401wt.eu-S934680AbXJSM5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934680AbXJSM5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 08:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763618AbXJSM4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 08:56:48 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:42323 "EHLO
	outbound3-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762146AbXJSM4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 08:56:46 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] x86: MCE optimization and cleanups
Date: Fri, 19 Oct 2007 14:54:55 +0200
Message-ID: <11927984973809-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.2.5
X-OriginalArrivalTime: 19 Oct 2007 12:54:58.0064 (UTC)
 FILETIME=[40E6C100:01C8124F]
MIME-Version: 1.0
X-WSS-ID: 6B0676DD0602385768-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset includes two patches.

1. Checks for the MCA fetures as early as possible and signedness fixup.
2. Minor coding style cleanup.




