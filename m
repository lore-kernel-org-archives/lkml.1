Return-Path: <linux-kernel-owner+w=401wt.eu-S1758386AbZCWImp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758386AbZCWImp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758331AbZCWImG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:42:06 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:64849 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758182AbZCWImE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:42:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=X4365HPHrVWV8+51EpTfuekqX9yZ1spwvuu6bdilu3QJPALmkkqgsC+YzR3I5xIY2j
         NKMTynItt4k5IjZ1lNtcZoiw7mR4XeYyl31KePihpniMH5rRyis3nNWJZiqJLP1XAPwK
         FP9+cLXx0nYUodxeawcxeOKUW87B5+Jpt6pkY=
Date: Mon, 23 Mar 2009 09:41:59 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: ftrace not working?
Message-ID: <20090323084158.GC5944@nowhere>
References: <200903231208.03723.knikanth@suse.de> <20090323071538.GA5944@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090323071538.GA5944@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 08:15:39AM +0100, Frederic Weisbecker wrote:
> On Mon, Mar 23, 2009 at 12:08:03PM +0530, Nikanth Karthikesan wrote:
> > Hi
> > 
> > I tried ftrace with the linus git 2.6.29 rc-6, & rc-8, but I always seem to
> > get empty trace! Am I doing something wrong?
> 
> 
> Hi Nikanth,
> 
> Does latest -tip tree work for you with about the same config?
> 
> http://people.redhat.com/mingo/tip.git/readme.txt
> 
> Thanks,
> Frederic.
> 

I've tested your config on latest mainline but not problem
occured with the sched switch tracer.

Does it work with other tracers?

