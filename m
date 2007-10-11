Return-Path: <linux-kernel-owner+w=401wt.eu-S1757526AbXJKMSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526AbXJKMSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 08:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbXJKMSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 08:18:14 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:56140 "EHLO
	outbound3-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752400AbXJKMSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 08:18:13 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] x86: MCE optimization and cleanups
Date: Thu, 11 Oct 2007 14:17:52 +0200
Message-ID: <11921050742274-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.2.5
X-OriginalArrivalTime: 11 Oct 2007 12:17:55.0476 (UTC)
 FILETIME=[C0D4BD40:01C80C00]
MIME-Version: 1.0
X-WSS-ID: 6B10CBF01DW1494532-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset includes two patches.

1. Checks for the MCA fetures as early as possible and signedness fixup.
2. Minor coding style cleanup.




