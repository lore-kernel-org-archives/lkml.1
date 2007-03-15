Return-Path: <linux-kernel-owner+w=401wt.eu-S933559AbXCONkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933559AbXCONkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 09:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933563AbXCONkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 09:40:23 -0400
Received: from 1wt.eu ([62.212.114.60]:1189 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933559AbXCONkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 09:40:22 -0400
Date: Thu, 15 Mar 2007 14:40:02 +0100
From: Willy Tarreau <w@1wt.eu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Syed Ahemed <kingkhan@gmail.com>, linux-kernel@vger.kernel.org,
       msnyder@redhat.com, jjohnstn@redhat.com
Subject: Re: NPTL patch for linux 2.4.28
Message-ID: <20070315134002.GB16199@1wt.eu>
References: <3d53b7120703131719y7bac2dccpb7bf8e32f7d45768@mail.gmail.com> <20070314055556.GP943@1wt.eu> <3d53b7120703141444k6484ccfeyd08cf60ecbbb894a@mail.gmail.com> <1173945186.25356.23.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173945186.25356.23.camel@twins>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 08:53:06AM +0100, Peter Zijlstra wrote:
> On Thu, 2007-03-15 at 03:14 +0530, Syed Ahemed wrote:
> 
> > Getting RHEL's source ( http://lkml.org/lkml/2005/3/21/380 ) was an
> > idea i thought about but then a download of the RHEL source from the
> > following location was denied .
> > http://download.fedora.redhat.com/pub/fedora/linux/core/1/SRPMS/  and
> > the rpmfind site.
> > (Guess need to be a paid subscriber for that right ?)
> 
> Strangely enough you try to download Fedora Core SRPMs whilst you speak
> of RHEL. Try this one:
> 
> ftp://ftp.redhat.com/pub/redhat/linux/enterprise/3/en/os/i386/SRPMS/kernel-2.4.21-4.EL.src.rpm
> 
> Also, CentOS would have similar sources. Google could have informed you
> on that.
> 
> > I still wonder why there aren't any NPTL patches available in the
> > non-redhat sites for kernels like 2.4.21 or more .
> 
> Because most people, especially the ones on this mailing list have moved
> on to 2.6 quite some time ago. May I suggest you do the same?

... or they stick to 2.4 for specific uses and do not need NPTL at all, which
came late in the development cycle.

Regards,
Willy

