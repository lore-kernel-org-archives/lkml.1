Return-Path: <linux-kernel-owner+w=401wt.eu-S1757691AbZGKI0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691AbZGKI0G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 04:26:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbZGKIZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 04:25:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44368 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163AbZGKIZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 04:25:54 -0400
Date: Sat, 11 Jul 2009 10:25:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1 tip] perf report: Adjust column width to the values
	sampled
Message-ID: <20090711082547.GA11522@elte.hu>
References: <20090706192157.GA3320@ghostprotocols.net> <20090710040104.GB5077@elte.hu> <20090711014728.GH3452@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090711014728.GH3452@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Em Fri, Jul 10, 2009 at 06:01:04AM +0200, Ingo Molnar escreveu:
> 
> <SNIP>
>  
> >   This is for easier output parsing for scripts.
> 
> Like this?

Perfect! :) Applied, thanks Arnaldo!

	Ingo
