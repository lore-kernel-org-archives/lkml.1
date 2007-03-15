Return-Path: <linux-kernel-owner+w=401wt.eu-S1752803AbXCOR2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbXCOR2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 13:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbXCOR2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 13:28:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:45762 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbXCOR2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 13:28:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=i8BMaZAN53VuNE0FsDq7E5sX6CqjVGVcuOhxtwvN3M1gFqsu1qZ/ziFXlt4pWgLDfW4LYKdWJcNsh+JKZ7Pje5vsb9qJovbd9+6bQ3DqLSbIQ9ecD7LYffQGHxl9/vWzyt7OhScWMeVfc074ziQlIFOiVLZA5Olh8wR975imH98=
Message-ID: <3d53b7120703151028g6232de75t8cca633d3ceb8ef@mail.gmail.com>
Date: Thu, 15 Mar 2007 22:58:39 +0530
From: "Syed Ahemed" <kingkhan@gmail.com>
To: "Willy Tarreau" <w@1wt.eu>
Subject: Re: NPTL patch for linux 2.4.28
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       msnyder@redhat.com, jjohnstn@redhat.com
In-Reply-To: <20070315134002.GB16199@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3d53b7120703131719y7bac2dccpb7bf8e32f7d45768@mail.gmail.com>
	 <20070314055556.GP943@1wt.eu>
	 <3d53b7120703141444k6484ccfeyd08cf60ecbbb894a@mail.gmail.com>
	 <1173945186.25356.23.camel@twins> <20070315134002.GB16199@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Point taken Sir , Change to 2.6 is inevitable i believe ....Allthough
i shall give the RHEL patch port to 2.4.28 a try over the weekend :-)
Thanks  a lot Willy and Peter for the help .

On 3/15/07, Willy Tarreau <w@1wt.eu> wrote:
> On Thu, Mar 15, 2007 at 08:53:06AM +0100, Peter Zijlstra wrote:
> > On Thu, 2007-03-15 at 03:14 +0530, Syed Ahemed wrote:
> >
> > > Getting RHEL's source ( http://lkml.org/lkml/2005/3/21/380 ) was an
> > > idea i thought about but then a download of the RHEL source from the
> > > following location was denied .
> > > http://download.fedora.redhat.com/pub/fedora/linux/core/1/SRPMS/  and
> > > the rpmfind site.
> > > (Guess need to be a paid subscriber for that right ?)
> >
> > Strangely enough you try to download Fedora Core SRPMs whilst you speak
> > of RHEL. Try this one:
> >
> > ftp://ftp.redhat.com/pub/redhat/linux/enterprise/3/en/os/i386/SRPMS/kernel-2.4.21-4.EL.src.rpm
> >
> > Also, CentOS would have similar sources. Google could have informed you
> > on that.
> >
> > > I still wonder why there aren't any NPTL patches available in the
> > > non-redhat sites for kernels like 2.4.21 or more .
> >
> > Because most people, especially the ones on this mailing list have moved
> > on to 2.6 quite some time ago. May I suggest you do the same?
>
> ... or they stick to 2.4 for specific uses and do not need NPTL at all, which
> came late in the development cycle.
>
> Regards,
> Willy
>
>


-- 
Azhar khan

I'm afraid that I've seen too many people fix bugs by looking at
debugger output, and that almost inevitably leads to fixing the
symptoms rather than the underlying problems.
	
--Linus
