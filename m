Return-Path: <linux-kernel-owner+w=401wt.eu-S1757261AbXGNQCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261AbXGNQCR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 12:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbXGNQCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 12:02:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765AbXGNQCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 12:02:05 -0400
Message-Id: <20070714175733.194012000@chello.nl>
User-Agent: quilt/0.45-1
Date: Sat, 14 Jul 2007 19:57:33 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Rostedt <rostedt@goodmis.org>,
       Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH -rt 0/5] making SLUB -rt friendly
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is an attempt at converting SLUB to -rt. It seems to work reasonably
well. But I haven't really pushed it _very_ _very_ hard yet.

Enjoy


--

