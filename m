Return-Path: <linux-kernel-owner+w=401wt.eu-S1757312AbXKFSvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbXKFSvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 13:51:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755605AbXKFSvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 13:51:22 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:1881 "EHLO
	outbound3-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755175AbXKFSvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 13:51:21 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: D6C75999-9DAF-4D89-B9AC-C25E3A0BB76A
Message-ID: <20071106183645.951275000@amd.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 Nov 2007 19:36:45 +0100
From: "Robert Richter" <robert.richter@amd.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "LKML" <linux-kernel@vger.kernel.org>
Subject: [patch 0/6] x86: apicdef.h unification
X-OriginalArrivalTime: 06 Nov 2007 18:47:57.0823 (UTC)
 FILETIME=[8C7500F0:01C820A5]
MIME-Version: 1.0
X-WSS-ID: 6B2E696A24S1590813-03-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch series unifies apicdef*h header files for the x86
architure. For a better review there are many small patches.


-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com



