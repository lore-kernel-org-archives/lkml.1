Return-Path: <linux-kernel-owner+w=401wt.eu-S1752850AbYJDFps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbYJDFps (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 01:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbYJDFpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 01:45:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:65400 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbYJDFpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 01:45:31 -0400
Date: Sat, 4 Oct 2008 01:45:28 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Arjan van de Ven <arjan@infradead.org>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: Add a C-state tracer to help power
 optimization
In-Reply-To: <20081003223347.27aa25ba@infradead.org>
Message-ID: <alpine.DEB.1.10.0810040141440.30107@gandalf.stny.rr.com>
References: <20081003165533.249261b1@infradead.org> <alpine.DEB.1.10.0810032003140.17863@gandalf.stny.rr.com> <20081003223347.27aa25ba@infradead.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 3 Oct 2008, Arjan van de Ven wrote:

> On Fri, 3 Oct 2008 20:32:51 -0400 (EDT)
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
> > Hi Arjan,
> > 
> > Very nice! I just have a few comments below.
> 
> since this is my first tracer.... I would suggest having a "golden
> example" one that people can copy (it seems I copied a less than
> perfect one ;-)... maybe a trace_example.c ?

Yeah, that would make sense to have.  People are starting to come
up with so many different tracers, I'm not sure what a golden
example would look like :-/

Some of my comments came about just noticing what you did and realized
that there's other ways to do it. I didn't think about those other
ways until I looked at your code ;-)

> 
> I'll look into your comments tomorrow when I'm more awake.

I'll comment more when I'm more awake. But that may not be until Monday.
Putting in 16 hour days during the week, my wife puts her foot down and
keeps me away from the computer during the weekend.

-- Steve

