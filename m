Return-Path: <linux-kernel-owner+w=401wt.eu-S1752529AbXBELQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbXBELQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 06:16:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbXBELQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 06:16:30 -0500
Received: from wr-out-0506.google.com ([64.233.184.224]:61045 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbXBELQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 06:16:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SlktsfGjGVJw6Om3WC+lql+RZyQMSTGf1TGFeQVht2Tl1rhaWC8SbDFTHkIkv9Tr5Ro6JjIWQ854T8XVxoZwxQllslV0hZ1jCgEHM2UnfrqmFYIoTBfgPxjQVXTZBgZL5UKLopky8dUkoAKoAibo1GCsgvzzrBd0+1X9M3LX1gk=
Message-ID: <8355959a0702050315y35eb0df9h4229d73226f064ea@mail.gmail.com>
Date: Mon, 5 Feb 2007 16:45:36 +0530
From: "Sunil Naidu" <akula2.shark@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: v2.6.20-rt1, yum/rpm
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <1170672153.4672.1.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070205065636.GA1652@elte.hu>
	 <8355959a0702050236k14aa8c98g29fdbac2c1370def@mail.gmail.com>
	 <1170672153.4672.1.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/5/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Mon, 2007-02-05 at 16:06 +0530, Sunil Naidu wrote:
> > On 2/5/07, Ingo Molnar <mingo@elte.hu> wrote:
> > > i have released the v2.6.20-rt1 kernel, which can be downloaded from the
> > > usual place:
> >
> > Clean boot for me with 2.6.20 & 2.6.20-rt1. There isn't any error
> > (like in 2.6.20-rc7-rt3).
> >
> > But here is an interesting dmesg:
> >
> > rcu_boost_dat: idx=1 b=0 ul=0 ub=0 boost: a=0 b=0
> > rcu_boost_dat block:    0  0  0  0?
> > rcu_boost_dat boost:    0! 0  0  0?
> > rcu_boost_dat unlock:   0? 0  0  0?
> >
> > I didn'tunderstand this with ? Am I missing anything here or please
> > give some inputs.
>
> That is Paul McKenney's RCU priority boosting stuff.
>
> Look here:
>   http://lkml.org/lkml/2007/1/24/294

Thanks for the input. I did check the URL to refer the update of the
patch by Paul:-

http://lkml.org/lkml/2007/01/15/219

I am getting error, The requested URL /lkml/2007/01/15/219. was not
found on this server.

~Akula2
