Return-Path: <linux-kernel-owner+w=401wt.eu-S1758690AbYAOWSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690AbYAOWSk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 17:18:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbYAOWSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 17:18:31 -0500
Received: from mail-dub.bigfish.com ([213.199.154.10]:10015 "EHLO
	mail105-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbYAOWSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 17:18:30 -0500
X-BigFish: V
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Subject: [PATCH 0/4] RT: fixes for kernel build errors on MIPS RBTX4927,
	2.6.24-rc7
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: frank.rowand@am.sony.com
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de
Content-Type: text/plain
Date: Tue, 15 Jan 2008 14:17:28 -0800
Message-Id: <1200435448.4092.11.camel@bx740>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jan 2008 22:18:28.0035 (UTC) FILETIME=[8D90E930:01C857C4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Rowand <frank.rowand@am.sony.com>

This patch series is a few small fixes to kernel build errors for
the Toshiba RBTX4927 MIPS board in the 2.6.24-rc7 kernel, with the
2.6.24-rc7-rt2 patch previously applied.  These patches are directly
related to the -rt2 patch, not to the vanilla MIPS tree.  A related
set of patches will be submitted to linux-mips.org.

Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>
---



