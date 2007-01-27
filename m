Return-Path: <linux-kernel-owner+w=401wt.eu-S1752270AbXA0OKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270AbXA0OKE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 09:10:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbXA0OKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 09:10:04 -0500
Received: from wx-out-0506.google.com ([66.249.82.232]:15900 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbXA0OKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 09:10:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Qh5GllycPrRcmZtU0rtlQT6sz3Ivk7mpsia3IhCUdfcAaG+5R5KWSBIjLmcFhDy08Dfpq4PUEGstnStw6Hggcq5jjhqx1gGACEXH77uLth6m+CfncSYLKnFp1rvP4mSeVQAw/tyxRuqCJB2jVqKwAGlJve3w9r2BAZc9X+MV++I=
Message-ID: <3877989d0701270610h7a950125n10d439c3bebce9d0@mail.gmail.com>
Date: Sat, 27 Jan 2007 22:10:00 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: "Joel Soete" <soete.joel@scarlet.be>
Subject: Re: 2.6.20-rc6 libata PATA ATAPI CDROM is not working
Cc: "Tejun Heo" <htejun@gmail.com>, "Alan Cox" <alan@redhat.com>,
       "Ioan Ionita" <opslynx@gmail.com>, Alan <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com
In-Reply-To: <45BB51F9.5070100@scarlet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <df47b87a0611161522o3ad007f5i8804c876c50e591c@mail.gmail.com>
	 <20061116235048.3cd91beb@localhost.localdomain>
	 <df47b87a0611161730p70e1dd41iad7d27a0bf9283ff@mail.gmail.com>
	 <df47b87a0611161734h818fc4dneaad5eeaa7e3c392@mail.gmail.com>
	 <20061117100559.GA10275@devserv.devel.redhat.com>
	 <459286C2.7080705@scarlet.be> <45943C15.4010506@scarlet.be>
	 <459B31AE.709@gmail.com> <459BE5AC.70703@scarlet.be>
	 <45BB51F9.5070100@scarlet.be>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Does acpi=off make cdrom work?

On 1/27/07, Joel Soete <soete.joel@scarlet.be> wrote:
> Hello all,
>
> I just tested libata with this newest 2.6.20-rc6 but no changes ;-(
>
> Any news?
>
> Thanks,
>         Joel
>
> Joel Soete wrote:
> > Hello Tejun,
> >
> > Tejun Heo wrote:
> >> Joel Soete wrote:
> >>> Hello Alan, Jeff,
> >>>
> >>> Reading a paper on this new libata, I just want to try but failled yet
> >>> for what said this thread "ATAPI CDROM" ;_(.
> >>>
> >>> I first test the latest stable 2.6.19.1 without luck, so I also want to
> >>> try latest 2.6.20-rc2 unfortunately without more success.
> >>
> >> I'm attaching two patches.  One against 2.6.19 the other against
> >> 2.6.20-rc3.  Both have about the same effect.  Please apply and report
> >> what happens and full dmesg.
> >>
> >> Thanks and happy new year.
> >>
> > Happy new year too ;-)
> >
> > Because of lack of time I only test your patch against 2.6.20-rc3.
> >
> > Unfortunately it doesn't help yet, sorry (i would very like to be of
> > more help).
> >
> > I here attache the full dmesg of my i386 boxe.
> >
> > Thanks again,
> >     Joel
> >
> >
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
