Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbXIOOdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbXIOOdU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 10:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbXIOOdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 10:33:14 -0400
Received: from qb-out-0506.google.com ([72.14.204.224]:13849 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbXIOOdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 10:33:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CFZXEUb+aE3O/mzumHFc31j1O1W7iNxWj1sW5CazgGfYd95bXj4Zb+Fs6JgurNLktwxkL4CPRBJ40nkC9AoUeXSCxdPfZu5PMxIl79Vt9FFl6OPz6qSRQVNWIcWPkcSWgzf23AFZI3LvsZaM7BaV31nZQcovkzX7kYqb1KjMrAc=
Message-ID: <d9def9db0709150733l1b35a5mad60fdcf8f6e66ec@mail.gmail.com>
Date: Sat, 15 Sep 2007 16:33:11 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
Cc: "Johannes Stezenbach" <js@linuxtv.org>,
       "Steven Toth" <stoth@hauppauge.com>,
       "Manu Abraham" <abraham.manu@gmail.com>,
       "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
In-Reply-To: <1189865082.5271.91.camel@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46E95C54.4060502@gmail.com> <46E9DDC7.4000403@hauppauge.com>
	 <d9def9db0709132338v64ecdcf2ib4e69f1a9c986a5c@mail.gmail.com>
	 <20070914113838.GA29962@linuxtv.org>
	 <d9def9db0709140936u64041927p9e472f70d5a036c5@mail.gmail.com>
	 <20070914204343.GA9058@linuxtv.org>
	 <d9def9db0709141829w449eb9eek9b7b6a714793cede@mail.gmail.com>
	 <20070915131650.GA12531@linuxtv.org>
	 <d9def9db0709150638o2e4026fbgd347eefc0fa4b3e6@mail.gmail.com>
	 <1189865082.5271.91.camel@gaivota>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/15/07, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> > Everyone knows that there are some issues even some internal
> > ones which I'm not part of.
>
> With respect to your kernel-userspace API for xc3028, you made something
> that seemed to be a dream: there's a consensus: not a single developer
> believed that this is the better way; nobody seems that this is the
> better approach.
>

Not a single developer out of 3-5 people? Seems fine with me, because
people didn't agree with anything else before either and tried to point
me to wrong solutions.
http://threebit.net/mail-archive/video4linux/msg07548.html

> So, or you are the only media developer with good sense in the face of
> the Earth, or you're incapable of understand the obvious: you're wrong
> with this approach. IMO, the answer is quite obvious.
>

that for you don't have to use it.
http://mcentral.de/wiki/index.php/Userspace_tuner#Advantages

I'm off for the weekend now so have a nice one :-)
Markus
