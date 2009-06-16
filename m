Return-Path: <linux-kernel-owner+w=401wt.eu-S1758097AbZFPUIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097AbZFPUIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbZFPUII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:08:08 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:40095 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbZFPUIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:08:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nqD/4json1xCNfWoDP2f1p1D22l+2JGMOMcXeMts+Pe+BsQsQct/LNQztc8KI7nywJ
         EtSnVq2oxIKHnpib2Tfndy8XKPvvANEOtM+2KiI5JOsY6qdP/3Y5bhOfZY7CrUjapXbS
         ydfdzfpWgC4SQtFyLNbUSjRIFTsY0Sn11ZCgs=
Date: Tue, 16 Jun 2009 22:08:05 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jake Edge <jake@lwn.net>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: problem with function_graph self-test?
Message-ID: <20090616200803.GA6111@nowhere>
References: <20090616122603.6a628097@chukar> <alpine.DEB.2.00.0906161436200.26673@gandalf.stny.rr.com> <20090616130443.721947e6@chukar> <alpine.DEB.2.00.0906161601290.26673@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0906161601290.26673@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 04:01:54PM -0400, Steven Rostedt wrote:
> On Tue, 16 Jun 2009, Jake Edge wrote:
> 
> > On Tue, 16 Jun 2009 14:37:10 -0400 (EDT) Steven Rostedt wrote:
> > 
> > > No I have not seen this before. Could you send me your config. And if
> > > you can take a digital picture of the dump (if one is available) that
> > > would also be helpful.
> > 
> > I'll tack the config on to the end of this message, I assume jpgs are
> > frowned upon for lkml so I will send those to you separately ... In
> > getting these, I also had a hang (with no dump) in the wakeup tracer
> > self-test ...
> 
> I'm able to reproduce it, I'll dig into it.
> 
> Thanks!
> 


Thanks for handling that, I won't have a lot of time to look at it
the next days :-/

