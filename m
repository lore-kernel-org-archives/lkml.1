Return-Path: <linux-kernel-owner+w=401wt.eu-S1760856AbXHaU7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760856AbXHaU7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 16:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761029AbXHaU7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 16:59:12 -0400
Received: from www.osadl.org ([213.239.205.134]:46055 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760438AbXHaU7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 16:59:09 -0400
Subject: v2.6.23-rc4-rt1 / new project URL
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: RT-Users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Fri, 31 Aug 2007 22:59:04 +0200
Message-Id: <1188593944.9647.15.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We're pleased to announce the release of the v2.6.23-rc4-rt1 kernel,
which can be downloaded from a new place:
 
   http://www.kernel.org/pub/linux/kernel/projects/rt/
 
The move to kernel.org is experimental for now, we'll keep it if it
works out fine.

Changes since 2.6.23-rc2-rt2:

- update to -rc4
- update to 2.6.23-rc4-hrt1

- UP compile fixes back merged (Kevin Hilman / Steven Rostedt)
- various latency tracer fixes (Steven Rostedt)
- softirq migration fixes (Steven Rostedt)
- ARM futex cmpxchg in atomic support (Khem Raj)
- ARM raw lock fix (Kevin Hilman)
- loadavgrt fix (Luis Claudio R. Goncalves)
- mellanox driver fix (Michael S. Tsirkin)

A bunch of patches are postponed for -rt2 (they are neither ignored
nor forgotten):

- simple_irq change (Kevin Hilman): needs more thought
- RCU updates (Paul McKenney): needs proper integration
- latency tracer changes (Daniel Walker): needs review
- PICK_OP changes (Daniel Walker): needs review


More info about the -rt patch set can be found in the RT wiki:
     
  http://rt.wiki.kernel.org
  
To build a 2.6.23-rc4-rt1 tree, the following patches should be applied:
 
  http://kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.22.tar.bz2
  http://kernel.org/pub/linux/kernel/v2.6/testing/patch-2.6.23-rc4.bz2
  http://kernel.org/pub/linux/kernel/projects/rt/patch-2.6.23-rc4-rt1.bz2

        Thomas, Ingo


