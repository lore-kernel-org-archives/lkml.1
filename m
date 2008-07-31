Return-Path: <linux-kernel-owner+w=401wt.eu-S1753062AbYGaKtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbYGaKtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 06:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751022AbYGaKtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 06:49:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34125 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbYGaKtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 06:49:40 -0400
Date: Thu, 31 Jul 2008 06:49:37 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: michael@ellerman.id.au, srostedt@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: Make output nicely spaced for up to 999 cpus
In-Reply-To: <20080730210144.0f4970c9.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0807310649270.30102@gandalf.stny.rr.com>
References: <ea127060ce3764c4b714406be0521171b925a847.1216192501.git.michael@ellerman.id.au> <20080725221124.GA837@goodmis.org> <1217476339.1487.24.camel@localhost> <20080730210144.0f4970c9.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 30 Jul 2008, Andrew Morton wrote:

> On Thu, 31 Jul 2008 13:52:19 +1000 Michael Ellerman <michael@ellerman.id.au> wrote:
> 
> > On Fri, 2008-07-25 at 18:11 -0400, Steven Rostedt wrote:
> > > On Wed, Jul 16, 2008 at 05:15:01PM +1000, Michael Ellerman wrote:
> > > > 
> > > > Currently some of the ftrace output goes skewiff if you have more
> > > > than 9 cpus, and some if you have more than 99.
> > > > 
> > > > Twiddle with the headers and format strings to make up to 999 cpus
> > > > display without causing spacing problems.
> > > > 
> > > > Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
> > > 
> > > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> 
> I switched that to Acked-by:.  A Signed-off-by: implies that you
> (co)authored the patch or that it went through your hands.  That does
> not appear to be the case here.

Ack.

-- Steve

> 
> > Hi Steven,
> > 
> > Is there an ftrace tree I should send this to? Or should I ask Andrew to
> > throw it in -mm ?
> 
> Normally Ingo handles ftrace but he will shortly be offline for a bit,
> so I'll suck up whatever Ingoish things happen to cross my desk.
> 
> 
