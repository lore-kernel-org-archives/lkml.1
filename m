Return-Path: <linux-kernel-owner+w=401wt.eu-S1764792AbYBMPV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764792AbYBMPV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 10:21:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755688AbYBMPVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 10:21:49 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:28839 "EHLO
	outbound5-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755074AbYBMPVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 10:21:48 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0JW6NYC-01-5PC-01
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
Message-ID: <20080213151811.804698000@amd.com>
User-Agent: quilt/0.46-1
From: "Robert Richter" <robert.richter@amd.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
cc: "LKML" <linux-kernel@vger.kernel.org>
Subject: [patch 0/2] x86: Add AMD Barcelona extended interrupt support
 for 32bit
Date: Wed, 13 Feb 2008 16:19:36 +0100 (CET)
X-OriginalArrivalTime: 13 Feb 2008 15:19:36.0602 (UTC)
 FILETIME=[D80B4FA0:01C86E53]
MIME-Version: 1.0
X-WSS-ID: 6BADD54E07S10443437-02-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for extended interrupts on AMD
Barcelona CPUs. Implementation is the same as it exists already for
64bit. Also EXPORT_SYMBOL macros are added to the 64bit code.

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com



