Return-Path: <linux-kernel-owner+w=401wt.eu-S1753121AbXCMFDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbXCMFDF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 01:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbXCMFDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 01:03:05 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:54264 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbXCMFDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 01:03:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LAKcm6ygsPnKgvZ14diT+MJQVHcF129ik5+Ige5NMzvKOaxCfjZRTwelqTQHHFf+iGVa+/NbeXuDOVRK86Ypz/NdvHXIYeboiq5tt6mcomzhAWvptO4ysrFqrVeYP1PpqjNY6U4iu2n3anx8CJHbcMMHChSbRQCl3xnNztdOPak=
Message-ID: <6f6293f10703122203i7f11f355j69f6b2e2e830051f@mail.gmail.com>
Date: Tue, 13 Mar 2007 01:03:00 -0400
From: "Felipe Alfaro Solana" <felipe.alfaro@gmail.com>
To: "Willy Tarreau" <w@1wt.eu>
Subject: Re: [ck] Re: RSDL v0.30 cpu scheduler for mainline kernels
Cc: "Con Kolivas" <kernel@kolivas.org>, ck@vds.kolivas.org,
       "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <20070313043206.GN943@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703121058.11966.kernel@kolivas.org>
	 <20070312.164652.108743760.davem@davemloft.net>
	 <200703131405.23482.kernel@kolivas.org> <20070313043206.GN943@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/13/07, Willy Tarreau <w@1wt.eu> wrote:
> On Tue, Mar 13, 2007 at 02:05:23PM +1100, Con Kolivas wrote:
> > On Tuesday 13 March 2007 10:46, David Miller wrote:
> > > From: Con Kolivas <kernel@kolivas.org>
> > > Date: Mon, 12 Mar 2007 10:58:11 +1100
> > >
> > > > http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3-sched-rsdl-0.
> > > >30.patch
> > >
> > > FWIW, this boots and seems to work well on sparc64.  Tested
> > > on UP SunBlade1500 and 24cpu Niagara T1000.
> >
> > Very nice. Thanks for the feedback and I'm sorry you have to work with such
> > lousy hardware.
>
> BTW, I don't know if you say this as a joke, but those are not necessarily
> lousy hardware. Sun does lousy hardware when they put Sparcs in PCs (ultra5,
> ultra10, blade100). But their servers generally are nice with large memory
> busses and very scalable SMP architectures.

I guess Con was kidding. A 24-CPU system can be anything but lousy hardware.
