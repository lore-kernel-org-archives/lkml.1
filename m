Return-Path: <linux-kernel-owner+w=401wt.eu-S1759330AbYGKOvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330AbYGKOvl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 10:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbYGKOve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 10:51:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58139 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbYGKOve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 10:51:34 -0400
Date: Fri, 11 Jul 2008 10:51:31 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] ftrace: updates
In-Reply-To: <20080711144725.GA23875@elte.hu>
Message-ID: <Pine.LNX.4.58.0807111051080.19993@gandalf.stny.rr.com>
References: <20080711005808.316194101@goodmis.org> <20080711135057.GC32159@elte.hu>
 <20080711144725.GA23875@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 11 Jul 2008, Ingo Molnar wrote:
>
> found a build bug in testing - find the fix below.

Acked-by: Steven Rostedt <srostedt@redhat.com>

Thanks Ingo!

-- Steve
