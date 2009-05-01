Return-Path: <linux-kernel-owner+w=401wt.eu-S932657AbZEAPBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657AbZEAPBB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 11:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765397AbZEAO4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:56:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50537 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765421AbZEAO4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:56:43 -0400
Date: Fri, 1 May 2009 16:55:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rostedt@goodmis.org, fweisbec@gmail.com, mathieu.desnoyers@polymtl.ca,
       randy.dunlap@oracle.com, wcohen@redhat.com
Subject: Re: [PATCH 0/3] add tracepoints docbook (take #2)
Message-ID: <20090501145528.GA7618@elte.hu>
References: <cover.1241107197.git.jbaron@redhat.com> <20090501142455.GA3111@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501142455.GA3111@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jason Baron <jbaron@redhat.com> wrote:

> On Thu, Apr 30, 2009 at 01:29:08PM -0400, Jason Baron wrote:
>
> > The following patches add a new tracepoint docbook. Since 
> > tracepoints can be defined by various macros and in various 
> > files, I think it important to clearly document the available 
> > tracepoints, as Andrew has pointed out. This helps us see what 
> > we have and what we don't have. If this patch is accepted, I 
> > hope that others will add docbook style comments, so we can have 
> > a complete accounting of the kernel's tracepoints.
> > 
> 
> hi,
> 
> i'd also like to get some agreement that future tracepoints need 
> to have this sort of documentation included when they are 
> submitted. Also, I'd like people who have already submitted 
> tracepoints to go back and add this kind of documentation. I'll 
> volunteer to police the effort if we agree it should be done.

sure - but sending patches would be even more useful than policing
:)

	Ingo
