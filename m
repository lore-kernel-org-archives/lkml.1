Return-Path: <linux-kernel-owner+w=401wt.eu-S1756172AbYDSGLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbYDSGLX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 02:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbYDSGLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 02:11:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41307 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbYDSGLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 02:11:13 -0400
Date: Sat, 19 Apr 2008 08:10:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       peterz@infradead.org, sandmann@redhat.com, pq@iki.fi,
       srostedt@redhat.com
Subject: Re: [PATCH 4/5] ftrace: limit trace entries
Message-ID: <20080419061055.GA17320@elte.hu>
References: <20080418200538.788522018@goodmis.org> <20080418200850.443055618@goodmis.org> <20080418131935.67daf8f0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080418131935.67daf8f0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 18 Apr 2008 16:05:42 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > +/**
> > + * detremine_dirtyable_memory - amount of memory that may be used
> 
> tpyo

thanks, fixed.

	Ingo
