Return-Path: <linux-kernel-owner+w=401wt.eu-S1762657AbZFPUCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762657AbZFPUCG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762679AbZFPUBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:01:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49097 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762691AbZFPUBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:01:53 -0400
Date: Tue, 16 Jun 2009 16:01:54 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jake Edge <jake@lwn.net>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: problem with function_graph self-test?
In-Reply-To: <20090616130443.721947e6@chukar>
Message-ID: <alpine.DEB.2.00.0906161601290.26673@gandalf.stny.rr.com>
References: <20090616122603.6a628097@chukar> <alpine.DEB.2.00.0906161436200.26673@gandalf.stny.rr.com> <20090616130443.721947e6@chukar>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009, Jake Edge wrote:

> On Tue, 16 Jun 2009 14:37:10 -0400 (EDT) Steven Rostedt wrote:
> 
> > No I have not seen this before. Could you send me your config. And if
> > you can take a digital picture of the dump (if one is available) that
> > would also be helpful.
> 
> I'll tack the config on to the end of this message, I assume jpgs are
> frowned upon for lkml so I will send those to you separately ... In
> getting these, I also had a hang (with no dump) in the wakeup tracer
> self-test ...

I'm able to reproduce it, I'll dig into it.

Thanks!

-- Steve
