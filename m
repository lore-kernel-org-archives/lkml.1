Return-Path: <linux-kernel-owner+w=401wt.eu-S1761001AbYGOCbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761001AbYGOCbn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753626AbYGOCbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:31:34 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:51643 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142AbYGOCbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:31:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=pLqhZqfWOsz/G2E9vKunpAdJaE3YmCNYIH09R5glbp2eCDsJ7eAcqja04wKniB4zaL
         cDwYSdY4SQy4txcLrJyhqN46Pj5iA8vBXAVC5uDiSQfgHObHPVzskJK8TNN6B7y5sEdG
         pKSHe+Sf6fo78qaH10nhqcfhd5rbMctb50zco=
Message-ID: <6d291e080807141931g3080c94cic94f503c1a18523b@mail.gmail.com>
Date: Mon, 14 Jul 2008 21:31:29 -0500
From: "Stoyan Gaydarov" <stoyboyker@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: From 2.4 to 2.6 to 2.7?
Cc: linux-kernel@vger.kernel.org, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       gorcunov@gmail.com, akpm@linux-foundation.org, mingo@elte.hu
In-Reply-To: <alpine.LFD.1.10.0807141914280.3017@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6d291e080807141910m573b29b2t753ea7c4db09902d@mail.gmail.com>
	 <alpine.LFD.1.10.0807141914280.3017@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2008 at 9:22 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Mon, 14 Jul 2008, Stoyan Gaydarov wrote:
>>
>> Second I wanted to talk about the linux 2.7.x kernel, whats in the
>> making or maybe even not started
>
> Nothing.
>
> I'm not going back to the old model. The new model is so much better that
> it's not even worth entertaining as a theory to go back.
I would also recomend staying away from the old model

>
> That said, I _am_ considering changing just the numbering. Not to go back
> to the old model, but because a constantly increasing minor number leads
> to big numbers. I'm not all that thrilled with "26" as a number: it's hard
> to remember.
The main reason I asked these questions is because we have 2.4.36 and
2.2.27 and those are pretty high numbers, so I thought maybe we would
start 2.7.x releases just so that they start back at 1
>
> So I would not dismiss (and have been thinking about starting) talk about
> a simple numbering reset (perhaps yearly), but the old model of 3-year
> developement trees is simply not coming back as far as I'm concerned.
>
> In fact, I think the time-based releases (ie the "2 weeks of merge window
> until -rc1, followed by roughly two months of stabilization") has been so
> successful that I'd prefer to skip the version numbering model too. We
> don't do releases based on "features" any more, so why should we do
> version _numbering_ based on "features"?
>
> For example, I don't see any individual feature that would merit a jump
> from 2.x to 3.x or even from 2.6.x to 2.8.x. So maybe those version jumps
> should be done by a time-based model too - matching how we actually do
> releases anyway.
Does it have to be even numbers only?

>
> So if the version were to be date-based, instead of releasing 2.6.26,
> maybe we could have 2008.7 instead. Or just increment the major version
> every decade, the middle version every year, and the minor version every
> time we make a release. Whatever.
I dont think people would agree with the 2008.7 version numbers
although it would make them more aware of how old the kernel and
prompt them to upgrade
>
> But three-year development trees with a concurrent stable tree? Nope. Not
> going to happen.
>
>                Linus
>
