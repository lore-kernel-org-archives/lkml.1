Return-Path: <linux-kernel-owner+w=401wt.eu-S1753954AbXIONiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbXIONiS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 09:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750717AbXIONiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 09:38:10 -0400
Received: from qb-out-0506.google.com ([72.14.204.238]:13638 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbXIONiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 09:38:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TFYtAxPvA7TrtdgoxA9VjBzhHWI/kt5qrR5VXz0vHADSDKxJaBcykdIkqsClHXcUPyxSo3dfED7Q4V4wl8LD+W0CzvsPVtjGO5KVPnrH0oORtH1K75Yb4nN5Z96ghdX6cUyB/JfSQybb+ebjTwqJAvM0oC8jVhuRZmuTjjySJJc=
Message-ID: <d9def9db0709150638o2e4026fbgd347eefc0fa4b3e6@mail.gmail.com>
Date: Sat, 15 Sep 2007 15:38:06 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Johannes Stezenbach" <js@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
Cc: "Steven Toth" <stoth@hauppauge.com>,
       "Manu Abraham" <abraham.manu@gmail.com>,
       "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
In-Reply-To: <20070915131650.GA12531@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46E95C54.4060502@gmail.com> <46E99F36.8090809@hauppauge.com>
	 <d9def9db0709131617l14495fecp5e15f91aa5dd9474@mail.gmail.com>
	 <46E9DDC7.4000403@hauppauge.com>
	 <d9def9db0709132338v64ecdcf2ib4e69f1a9c986a5c@mail.gmail.com>
	 <20070914113838.GA29962@linuxtv.org>
	 <d9def9db0709140936u64041927p9e472f70d5a036c5@mail.gmail.com>
	 <20070914204343.GA9058@linuxtv.org>
	 <d9def9db0709141829w449eb9eek9b7b6a714793cede@mail.gmail.com>
	 <20070915131650.GA12531@linuxtv.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/15/07, Johannes Stezenbach <js@linuxtv.org> wrote:
> On Sat, Sep 15, 2007, Markus Rechberger wrote:
> >
> > it gets me thinking. Some core developers who I met during
> > the last few weeks (kernel summit, suse conference in czech)
> > told me to go on with it actually because the final plan isn't that
> > bad..
>
> I was referring to your code you posted for merging on linux-dvb,
> and which got rejected. Anyway, it's easy to agree with you if one
> has just heard _your_ version -- the purpose of this thread is to
> give people an alternate version of the story to complement
> yours, which would allow the people you talked to to think it over
> and change their mind. See if you can get of those people you
> talked to to post here to support you.
>

Everyone knows that there are some issues even some internal
ones which I'm not part of.
Not sure if you met some other kernel developers recently, all you
can hear is "those crazy media guys" (which just includes everyone
who works with media related drivers)

> > Beside that I'm just curious how much did you contribute
> > during the last 2 years to the lkml/linux kernel, and how much
> > do you want to contribute in future? (also from my side
> > talk is cheap (even for me) but getting something done costs
> > quite some time and feedback from other people)
>
> IOW you say if I don't write code I should shut up?
> Is that also what you tell users on your em28xx list
> when they dare to disagree with you?
>
> Nice...
>

This is a free world you can write whatever you want,
but if you want me to change my code you need to
convince me that I should acknowlidge your ideas.
And by not acknowlidging my requirements don't expect
that I will go back to the start and try to reinvent the
wheel. After almost 2 years I'm quite into those things
and I know what I want for my project and what I'll try
to achieve with what I'm doing.

Markus
