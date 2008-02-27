Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbYB0Qkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbYB0Qkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 11:40:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754614AbYB0Qkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 11:40:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754359AbYB0Qkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 11:40:36 -0500
Date: Wed, 27 Feb 2008 11:39:55 -0500
From: Kyle McMartin <kmcmartin@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kyle McMartin <kmcmartin@redhat.com>,
       =?iso-8859-1?B?Uy7HYT8/bGFy?= Onur <caglar@pardus.org.tr>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       lguest@ozlabs.org, rusty@rustcorp.com.au
Subject: Re: Linux 2.6.25-rc3
Message-ID: <20080227163955.GL12908@kibblesnbits.boston.devel.redhat.com>
References: <alpine.LFD.1.00.0802241354200.14934@woody.linux-foundation.org> <200802250129.17526.caglar@pardus.org.tr> <20080225071605.GA11327@elte.hu> <20080227161207.GJ12908@kibblesnbits.boston.devel.redhat.com> <20080227161649.GA799@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080227161649.GA799@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 05:16:50PM +0100, Ingo Molnar wrote:
> 
> * Kyle McMartin <kmcmartin@redhat.com> wrote:
> 
> > On Mon, Feb 25, 2008 at 08:16:05AM +0100, Ingo Molnar wrote:
> > > this fix still fails for some randconfig combinations - the fuller fix 
> > > is queued up in x86.git#testing.
> > 
> > great. I really just added it to fix Fedora's configs. I'll drop it 
> > from there once it hits -git snapshots.
> 
> the commits are upstream already:
> 
>  commit 1ce70c4fac3c3954bd48c035f448793867592bc0
>  commit db342d216ba9e060d8c5501eefc1d0a789c9e711
>  commit cbc34973709eb41b369c304c075cf2069f847012
> 
> so they should be in the latest git snapshots.
> 

Ah, davej has already updated to -git1. Excellent.

Thanks!
	Kyle
