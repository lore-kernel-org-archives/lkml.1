Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917AbZBEBow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbZBEBow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:44:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757153AbZBEBol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:44:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33595 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173AbZBEBok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:44:40 -0500
Date: Wed, 4 Feb 2009 20:44:25 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip 1/1] trace: assign defaults at
 register_ftrace_event
In-Reply-To: <20090205012430.GA12067@elte.hu>
Message-ID: <alpine.DEB.1.10.0902042043510.27726@gandalf.stny.rr.com>
References: <20090204221639.GO3440@ghostprotocols.net> <20090204234150.GA11300@nowhere> <20090205012210.GQ3440@ghostprotocols.net> <20090205012430.GA12067@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 5 Feb 2009, Ingo Molnar wrote:
> > > 
> > > Nice! This avoids one branch for each entry printed.
> > 
> > Is that an Acked-by in response to that CC? :-)
> 
> yes, i generally treat such replies as an implicit Acked-by and add them - 
> already added Fredric's acks to two other commits of yours earlier today. An 
> explicit Acked-by is even more helpful though :-)

Although it is probably too late, I'll join in on the fun.

Acked-by: Steven Rostedt <srostedt@redhat.com>

-- Steve

