Return-Path: <linux-kernel-owner+w=401wt.eu-S1753488AbYASGsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbYASGsj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 01:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbYASGs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 01:48:29 -0500
Received: from ns2.suse.de ([195.135.220.15]:35789 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbYASGs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 01:48:29 -0500
From: Andi Kleen <ak@suse.de>
Message-Id: <20080119748.170864000@suse.de>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] [0/8] GBpages support for x86-64, v2
Date: Sat, 19 Jan 2008 07:48:28 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch series supports using the new GB pages introduced with 
AMD Quad Cores for the kernel direct mapping.

I addressed all reasonable feedback for the previous version I believe.

Changes against previous version:
- Ported on top of latest git-x86 with PAT series
- Fixed some white space
- Clarify clear_kernel_mapping comments
- Minor cleanups

-Andi
