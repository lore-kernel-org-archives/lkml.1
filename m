Return-Path: <linux-kernel-owner+w=401wt.eu-S1756924AbYGKLJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbYGKLJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 07:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757853AbYGKLCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 07:02:51 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:37263 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757809AbYGKLCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 07:02:49 -0400
X-BigFish: VPS20(zz62a3Lzz10d3izzz32i87il43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3U9CA-01-XCZ-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] x86/pci: Renaming numa into numaq
Date: Fri, 11 Jul 2008 12:18:39 +0200
Message-ID: <1215771521-6848-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
X-OriginalArrivalTime: 11 Jul 2008 11:02:35.0804 (UTC) FILETIME=[A01505C0:01C8E345]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series renames numa into numaq for x86/pci code.

-Robert

--
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com



