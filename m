Return-Path: <linux-kernel-owner+w=401wt.eu-S1763335AbZFLIlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763335AbZFLIlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 04:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763190AbZFLIk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 04:40:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51388 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760490AbZFLIk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 04:40:26 -0400
Date: Fri, 12 Jun 2009 10:33:49 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2] posix-cpu-timers: random fixes rework -v2
Message-ID: <20090612103349.456590e5@dhcp-lab-109.englab.brq.redhat.com>
Organization: RedHat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two fixes related with posix-cpu-timers

Things changed in -v2:
patch 1 - add more exact description what happens 
patch 2 - fix bug where rcu_read_lock() was used instead of rcu_read_unlock()

Cheers
Satanislaw


