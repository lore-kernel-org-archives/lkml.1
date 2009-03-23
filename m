Return-Path: <linux-kernel-owner+w=401wt.eu-S1756622AbZCWLZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbZCWLZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 07:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755125AbZCWLZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 07:25:19 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:22447 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917AbZCWLZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 07:25:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Hy9iYF7lFnY79eOxRSppLJWES66An5RduREJaDYJrzGomxE16+NglA0W38NDG/XSdc
         uU65CyVzgjQSboIbIgCcd8BzrNP5NqvNCm7P/48S4efgYAd1Dnfvx0zR1CK1zs0sH7KQ
         3xIcNoffc0XRpjcaDapmuV+WbVyOGc2ym6Isg=
Date: Mon, 23 Mar 2009 12:25:11 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: ftrace not working?
Message-ID: <20090323112510.GA12071@nowhere>
References: <200903231208.03723.knikanth@suse.de> <20090323071538.GA5944@nowhere> <20090323084158.GC5944@nowhere> <200903231414.20483.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903231414.20483.knikanth@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 02:14:20PM +0530, Nikanth Karthikesan wrote:
> On Monday 23 March 2009 14:11:59 Frederic Weisbecker wrote:
> > On Mon, Mar 23, 2009 at 08:15:39AM +0100, Frederic Weisbecker wrote:
> > > On Mon, Mar 23, 2009 at 12:08:03PM +0530, Nikanth Karthikesan wrote:
> > > > Hi
> > > >
> > > > I tried ftrace with the linus git 2.6.29 rc-6, & rc-8, but I always
> > > > seem to get empty trace! Am I doing something wrong?
> > >
> > > Hi Nikanth,
> > >
> > > Does latest -tip tree work for you with about the same config?
> > >
> > > http://people.redhat.com/mingo/tip.git/readme.txt
> > >
> > > Thanks,
> > > Frederic.
> >
> > I've tested your config on latest mainline but not problem
> > occured with the sched switch tracer.
> >
> > Does it work with other tracers?
> 
> I tried "function" as well. None of the tracers seems to work.
> 
> Thanks
> Nikanth


Could you send your dmesg please?

