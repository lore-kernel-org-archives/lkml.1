Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbZAHMA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbZAHMA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 07:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbZAHMAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 07:00:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59090 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643AbZAHMAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 07:00:13 -0500
Date: Thu, 8 Jan 2009 12:59:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH] ring_buffer: fix ring_buffer_event_length()
Message-ID: <20090108115958.GB1539@elte.hu>
References: <alpine.DEB.1.10.0901072356480.14345@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901072356480.14345@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Hi Ingo,
> 
> I added the Impact line. This probably should go into 2.6.29.
> 
> The following patch is in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: tip/devel
> 
> 
> Robert Richter (1):
>       ring_buffer: fix ring_buffer_event_length()

applied to tip/tracing/urgent, thanks guys!

sidenote:

>     ring_buffer: fix ring_buffer_event_length()
>     
>     Impact: fix to ring_buffer_event_length()

That is a pretty useless duplication of the subject line, so i dropped it. 
When the subject line explains the practical impact already, there's no 
need to add the impact line.

	Ingo
