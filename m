Return-Path: <linux-kernel-owner+w=401wt.eu-S1759254AbZKZH7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759254AbZKZH7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 02:59:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759206AbZKZH7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 02:59:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43528 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759202AbZKZH7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 02:59:30 -0500
Date: Thu, 26 Nov 2009 08:59:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] tracing: Convert some trace events to DEFINE_TRACE
Message-ID: <20091126075930.GB8011@elte.hu>
References: <4B0E2807.4060102@cn.fujitsu.com>
 <1259220777.21397.75.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259220777.21397.75.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 2009-11-26 at 15:02 +0800, Li Zefan wrote:
> > Convert some trace events defined in include/trace/events/*.h
> > to DEFINE_TRACE and DEFINE_TRACE_PRINT.
> > 
> > This reduces hundreds of code lines, and shrinks the size
> > of object files.
> > 
> > Tested by comparing the formats of each trace_event before
> > and after patching.
> > 
> > This patchset is based on -tip tree, but I've conformed the
> > ext4 bits won't conflict with ext4 tree.
> 
> Thanks Li!
> 
> Ingo or Frederic,
> 
> Can you pull these in and test them. I'm about to celebrate my turkey 
> dinner, and I wont be back until Monday.

Yep, i'm on it.

	Ingo
