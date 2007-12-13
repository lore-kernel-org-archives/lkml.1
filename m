Return-Path: <linux-kernel-owner+w=401wt.eu-S1765611AbXLMU4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765611AbXLMU4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 15:56:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757181AbXLMU4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 15:56:45 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:39384 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756697AbXLMU4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 15:56:44 -0500
Date: Thu, 13 Dec 2007 15:56:37 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Gautham R Shenoy <ego@in.ibm.com>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, Paul E McKenney <paulmck@us.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ted Tso <tytso@us.ibm.com>,
       dvhltc@us.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>, bunk@kernel.org,
       Josh Triplett <josh@freedesktop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH 0/6] RCU: Preemptible-RCU
In-Reply-To: <20071213204219.GF25130@elte.hu>
Message-ID: <Pine.LNX.4.58.0712131555130.16714@gandalf.stny.rr.com>
References: <20071213170348.GA25981@in.ibm.com> <Pine.LNX.4.58.0712131230220.3369@gandalf.stny.rr.com>
 <20071213204219.GF25130@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 13 Dec 2007, Ingo Molnar wrote:
> Steve, if you went with a fine comb over the code and have done a
> thorough review, could you send me your Reviewed-by line for this
> patchset?

Sure thing. And here's the thread that contains a lot of my review (and I
had some with Paul on IRC).

http://lkml.org/lkml/2007/9/10/213

Reviewed-by: Steven Rostedt <srostedt@redhat.com>

