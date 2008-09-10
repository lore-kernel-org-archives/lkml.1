Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119AbYIJNTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbYIJNTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 09:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbYIJNTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 09:19:41 -0400
Received: from mx1.suse.de ([195.135.220.2]:35069 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbYIJNTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 09:19:41 -0400
Date: Wed, 10 Sep 2008 06:18:55 -0700
From: Greg KH <gregkh@suse.de>
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       htejun@gmail.com
Subject: Re: [PATCH] x86: sysfs - kill owner field from attribute
Message-ID: <20080910131855.GA15808@suse.de>
References: <f7848160809091611w50270265hc149baeaf267775e@mail.gmail.com> <20080910053724.GA3632@suse.de> <f7848160809100601o56340cf2re9f43cf0c3969d19@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7848160809100601o56340cf2re9f43cf0c3969d19@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 09:01:48AM -0400, Parag Warudkar wrote:
> On Wed, Sep 10, 2008 at 1:37 AM, Greg KH <gregkh@suse.de> wrote:
> 
> > Why one arch, normally we do it one subsystem at a time :)
> 
> Mostly because I at least want to compile test and preferably boot
> with the changes - which I can on x86/64.
> And somewhat in the hope that some one else will help with changes on
> the arches he/she is able to test!
> 
> >
> > Either way, thanks for doing this, I'll gladly take your fixed up
> > version and work to clean up the rest if you don't want to do it.
> >
> 
> Not that I don't want to do it - just that I can't test it on the
> other arches - so please feel free.
> The sooner it goes away the better.

Cross-compilers are your friend, Andrew beat that into me finally after
years of telling me this :)

resend your patch and I'll run with it.

thanks,

greg k-h
