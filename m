Return-Path: <linux-kernel-owner+w=401wt.eu-S1764975AbXGYHbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764975AbXGYHbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 03:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbXGYHa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 03:30:57 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:10745 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbXGYHa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 03:30:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=g3Z1F2AbJ+3BBR9me6M5DCy2t0BDzDFYWBwDUfXP0GpoHCo1uZQUIaw+njV7V/te8WOjxmdpusizJ2kN8UjMwqrNN5lBCjwvR1ikZKzJyFy7wB2hqn5P3lzAI05HhdhpLUoIWpmnRD0zobgocQXw2wC7kUXqLYWfaf2OeAJMnqs=
Message-ID: <a8e1da0707250030w7f200495s9b67686d25cd6c61@mail.gmail.com>
Date: Wed, 25 Jul 2007 07:30:55 +0000
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: make randconfig improvement
Cc: kai@germaschewski.name, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070725065426.GA24093@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0707242342s31166a5ax602fbcde8a299c97@mail.gmail.com>
	 <20070725065426.GA24093@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>On 7/25/07, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Wed, Jul 25, 2007 at 06:42:38AM +0000, Dave Young wrote:
> > Hi,
> > IMHO, the randconfig option make no sense sometimes. For me, My
> > computer need some must-have config options, like SATA and USB
> > keyboard config options. I think many other people maybe have similar
> > problems.
> >
> > So, what about improve the randconfig?  let's add some basic options ,
> > like oldconfig.   We can use randconfig based user-defined options,
> > randing except the pre-defined ones.
> >
> > What's your opinons?
>
> kconfig has support for reading a file specified by by
> $KCONFIG_ALLCONFIG or if not specified for randconfig to read
> a file named allrandom.config.
>
> The syntax of the files are the same as in .config.
>
> How far is this from what you try to achieve?
>
>         Sam
>
Yes, it does achieve my goal, thanks. sorry for this noise.
