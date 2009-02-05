Return-Path: <linux-kernel-owner+w=401wt.eu-S1762137AbZBEBiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762137AbZBEBiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755903AbZBEBiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:38:07 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47779 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717AbZBEBiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:38:05 -0500
Date: Wed, 4 Feb 2009 23:37:45 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip 1/1] trace: assign defaults at register_ftrace_event
Message-ID: <20090205013745.GR3440@ghostprotocols.net>
References: <20090204221639.GO3440@ghostprotocols.net> <20090204234150.GA11300@nowhere> <20090205012210.GQ3440@ghostprotocols.net> <20090205012430.GA12067@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205012430.GA12067@elte.hu>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Feb 05, 2009 at 02:24:30AM +0100, Ingo Molnar escreveu:
> * Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
> > Em Thu, Feb 05, 2009 at 12:41:51AM +0100, Frederic Weisbecker escreveu:
> > > Nice! This avoids one branch for each entry printed.
> > 
> > Is that an Acked-by in response to that CC? :-)
> 
> yes, i generally treat such replies as an implicit Acked-by and add them - 
> already added Fredric's acks to two other commits of yours earlier today. An 
> explicit Acked-by is even more helpful though :-)

I really appreciate that, this fine granularity on who is doing what is
really refreshing, deserved and encouraging.

- Arnaldo
