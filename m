Return-Path: <linux-kernel-owner+w=401wt.eu-S1764649AbZLQMXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764649AbZLQMXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 07:23:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764634AbZLQMXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 07:23:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56130 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764602AbZLQMXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 07:23:22 -0500
Date: Thu, 17 Dec 2009 13:23:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 0/6] a perf and some sched patches
Message-ID: <20091217122304.GA6365@elte.hu>
References: <20091217121626.682772324@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091217121626.682772324@chello.nl>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Fixes an issue with the per-task-per-cpu counters, reported by acme. Fixes 
> an false positive in the set_task_cpu() debug check, reported by Ingo. Fixes 
> up the task->state to char bits, gumbled at by tglx.

Applied, thanks Peter!

	Ingo
