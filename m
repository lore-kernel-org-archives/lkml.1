Return-Path: <linux-kernel-owner+w=401wt.eu-S1752264AbXLBNWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbXLBNWD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 08:22:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753412AbXLBNVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 08:21:39 -0500
Received: from mail-dub.bigfish.com ([213.199.154.10]:22467 "EHLO
	mail64-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbXLBNVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 08:21:38 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] x86_64: some minor paging cleanups
Date: Sun,  2 Dec 2007 14:21:18 +0100
Message-ID: <11966016811565-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.2.5
X-OriginalArrivalTime: 02 Dec 2007 13:21:21.0695 (UTC)
 FILETIME=[3AFEAAF0:01C834E6]
MIME-Version: 1.0
X-WSS-ID: 6B4C6EDE0QK3513727-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small series of patches cleans up the definition and use of the _PAGE_*
and __PAGE_KERNEL* permissions for the x86_64 code in the x86 architecture a
little bit.




