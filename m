Return-Path: <linux-kernel-owner+w=401wt.eu-S1752481AbYLSQSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbYLSQSi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 11:18:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751320AbYLSQSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 11:18:30 -0500
Received: from www.tglx.de ([62.245.132.106]:48451 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbYLSQS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 11:18:29 -0500
Message-Id: <20081219155504.735865178@linutronix.de>
User-Agent: quilt/0.46-1
Date: Fri, 19 Dec 2008 16:02:28 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <clark.williams@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>,
       Linux-rt <linux-rt-users@vger.kernel.org>
Subject: [patch 0/7] 2.6.24.7-rt24 bugfixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patchset fixes a long standing wakeup bug and a state
printout problem in the tracer.

Thanks,

	tglx
-- 

