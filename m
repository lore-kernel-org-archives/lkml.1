Return-Path: <linux-kernel-owner+w=401wt.eu-S1759919AbYAFQYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759919AbYAFQYs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 11:24:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757536AbYAFQXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 11:23:21 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:7915 "EHLO
	viefep34-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756541AbYAFQXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 11:23:15 -0500
Message-Id: <20080106161128.152634000@chello.nl>
User-Agent: quilt/0.45-1
Date: Sun, 06 Jan 2008 17:11:28 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       dmitry.adamushko@gmail.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 00/11] another rt group sched update
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this time compile tested on all 16 combinations of:

  CONFIG_SMP
  CONFIG_FAIR_GROUP_SCHED
  CONFIG_HIGH_RES_TIMERS
  CONFIG_NO_HZ

ran some but not all combinations
--

