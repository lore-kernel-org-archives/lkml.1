Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbZCWIq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbZCWIq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755857AbZCWIqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:46:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39999 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755460AbZCWIqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:46:46 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: ftrace not working?
Date: Mon, 23 Mar 2009 14:14:20 +0530
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc8-default; KDE/4.1.3; x86_64; ; )
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
References: <200903231208.03723.knikanth@suse.de> <20090323071538.GA5944@nowhere> <20090323084158.GC5944@nowhere>
In-Reply-To: <20090323084158.GC5944@nowhere>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903231414.20483.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 March 2009 14:11:59 Frederic Weisbecker wrote:
> On Mon, Mar 23, 2009 at 08:15:39AM +0100, Frederic Weisbecker wrote:
> > On Mon, Mar 23, 2009 at 12:08:03PM +0530, Nikanth Karthikesan wrote:
> > > Hi
> > >
> > > I tried ftrace with the linus git 2.6.29 rc-6, & rc-8, but I always
> > > seem to get empty trace! Am I doing something wrong?
> >
> > Hi Nikanth,
> >
> > Does latest -tip tree work for you with about the same config?
> >
> > http://people.redhat.com/mingo/tip.git/readme.txt
> >
> > Thanks,
> > Frederic.
>
> I've tested your config on latest mainline but not problem
> occured with the sched switch tracer.
>
> Does it work with other tracers?

I tried "function" as well. None of the tracers seems to work.

Thanks
Nikanth
