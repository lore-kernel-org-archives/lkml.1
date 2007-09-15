Return-Path: <linux-kernel-owner+w=401wt.eu-S932679AbXIOB3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679AbXIOB3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 21:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759525AbXIOB3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 21:29:07 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:56733 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbXIOB3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 21:29:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ihn83TGYvHdCFvI/QKcP/PB0fcmr25VA1eZkWzqFumZeY9aabCdZ7QkFjgFUgDac7/6QllqL/Y9ybFEwmUiuBEXdt+KyT2yvSqfRwCWgQGE+36Caj2J3JkkNwidQ7njGpTngaXhLSzTLbTucwNOpwlNUf2PPvnAwgkyq2p/AL3c=
Message-ID: <d9def9db0709141829w449eb9eek9b7b6a714793cede@mail.gmail.com>
Date: Sat, 15 Sep 2007 03:29:05 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Johannes Stezenbach" <js@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
Cc: "Steven Toth" <stoth@hauppauge.com>,
       "Manu Abraham" <abraham.manu@gmail.com>,
       "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
In-Reply-To: <20070914204343.GA9058@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070913131353.GB26972@linuxtv.org> <46E95C54.4060502@gmail.com>
	 <d9def9db0709130908r6e383c51wd115dd56cfe2beef@mail.gmail.com>
	 <46E99F36.8090809@hauppauge.com>
	 <d9def9db0709131617l14495fecp5e15f91aa5dd9474@mail.gmail.com>
	 <46E9DDC7.4000403@hauppauge.com>
	 <d9def9db0709132338v64ecdcf2ib4e69f1a9c986a5c@mail.gmail.com>
	 <20070914113838.GA29962@linuxtv.org>
	 <d9def9db0709140936u64041927p9e472f70d5a036c5@mail.gmail.com>
	 <20070914204343.GA9058@linuxtv.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/14/07, Johannes Stezenbach <js@linuxtv.org> wrote:
> On Fri, Sep 14, 2007, Markus Rechberger wrote:
> >
> > people do contribute to the em28xx project.
> ...
> > there's also an active and even problem solving oriented ML available:
> > http://mcentral.de/pipermail/em28xx/
> >
> > Also if you look at the mercurial code you'll see several people
> > contributing to that project.
>
> Of course, people who own such a device and want to use
> it with Linux have no choice but to work with you.
> And you do a good job for your users, you support them
> well and in return they contribute info and patches
> to support new devices.
>
> But the thing is that at mcentral.de you're the man at the top,
> and your users will hardly disagree with you on core
> technical questions. (Well, admittedly I'm speculating
> here as I don't read your em28xx list.)
>

they can. Put technical issues infront of everything also see the
whole picture that userspace tv applications have to support
all the codecs which are available.

> On for drivers/media/ OTOH you are just one developer among others,
> and some of them choose to disagree with you. Even worse,
> IIRC there wasn't even _a single_ other developer willing
> to ACK your offending patch.
>

there was not a single developer of the old crufted developers who
didn't bring the project forward during the last 2 years.
yes you're right.

> Now, doesn't _that_ get you thinking?
>

it gets me thinking. Some core developers who I met during
the last few weeks (kernel summit, suse conference in czech)
told me to go on with it actually because the final plan isn't that
bad.. I don't expect anyone of the old crufted v4l/dvb (well many
of them already left the party) will join the game...
(I'll leave that open here) spend some time read the whole history
of this thread and it will show up what this all is targeting at.
I'll answer your questions with technical reasons why I'm doing
all that stuff that way if you'll just ask.
Someone told me during the last 2 weeks
 "but v4l2 was about to solve all those problems" it didn't. (point)
and I think I explained good enough why all that crap still goes
on as it is.

Beside that I'm just curious how much did you contribute
during the last 2 years to the lkml/linux kernel, and how much
do you want to contribute in future? (also from my side
talk is cheap (even for me) but getting something done costs
quite some time and feedback from other people)

Markus
