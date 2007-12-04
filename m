Return-Path: <linux-kernel-owner+w=401wt.eu-S1755145AbXLDP1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145AbXLDP1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 10:27:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbXLDP1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 10:27:21 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:52977 "EHLO
	outbound5-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754570AbXLDP1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 10:27:19 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] x86_64: some minor paging cleanups
Date: Tue,  4 Dec 2007 16:23:48 +0100
Message-ID: <11967818313616-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.2.5
X-OriginalArrivalTime: 04 Dec 2007 15:23:51.0069 (UTC)
 FILETIME=[AC63A4D0:01C83689]
MIME-Version: 1.0
X-WSS-ID: 6B4BAE862IW3685834-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small series of patches cleans up the definition and use of the _PAGE_*
and __PAGE_KERNEL* permissions for the x86_64 code in the x86 architecture a
little bit.

The scripts are checked by checkpatch.pl now.




