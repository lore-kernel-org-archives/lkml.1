Return-Path: <linux-kernel-owner+w=401wt.eu-S932836AbXBTFTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836AbXBTFTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 00:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932852AbXBTFTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 00:19:53 -0500
Received: from nz-out-0506.google.com ([64.233.162.234]:16812 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932836AbXBTFTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 00:19:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tg3cOHHJTIL9W4j1rK4NLjfeRnCfgSAqDHgxiATgybEoQFOTg+e7Fwap2XLHXGsuoe1hfoFkQT0enYOhogtAiJh4a7nbAh5q7P9iIeB0oEGfl4qC7f6Tw48yTnop2SGdJG2uZkPW6i0IsCYnwegvwY3lcLb14y++tV9mdEvSoyc=
Message-ID: <9b3a62ab0702192119l1bf9a284la93c9d1f01638ca4@mail.gmail.com>
Date: Mon, 19 Feb 2007 21:19:49 -0800
From: "v j" <vj.linux@gmail.com>
To: davids@webmaster.com
Subject: Re: GPL vs non-GPL device drivers
Cc: trent.waddington@gmail.com,
       "Michael K. Edwards" <medwards.linux@gmail.com>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       "Neil Brown" <neilb@suse.de>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKIEFNBLAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3d57814d0702191458l1021caeyaefd7775398c5f2a@mail.gmail.com>
	 <MDEHLPKNGKAHNMBLJOLKIEFNBLAC.davids@webmaster.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> You are trying to cram this in a simple yes or no box, and it just doesn't
> fit. There are questions nobody knows the answers to (such as what rights
> you need to distribute a derivative work or whether compiling code makes a
> translation).

Thanks, all for the discussion. I certainly learnt a lot. I definitely
expected to be flamed and roasted for posting my original message, and
was not disappointed :)

I do not possess all the knowledge ("legal" and technical) that people
who have contributed to this discussion possess. However I will still
comment from a user's perspective, which was my original point.

Many companies in the embedded field still mistakenly feel (or felt
until a while ago) that Linux was not right for them. That they would
have to open source their code, that they would not get adequate
support, and that Linux was too big and heavy to perform well in an
embedded platform. People like me who were Linux Desktop junkies were
actually trying to convince companies of the opposite.

Now the popularity of Linux is exploding in the embedded space. Nobody
talks of VxWorks and OSE anymore. It is all Linux. Perhaps it would be
a worthwhile experiment to study this surge in popularity. I am not an
expert, but perhaps the reason is "it works so goddamn well and has a
wealth of third party FREE software". Sure its a bit of work to make
it work on our platform and we don't have to Enea or Windriver to
write our gripes to. But it definitely is worth it.

Now it would also be worthwhile to contemplate what EXPORT_SYMBOL_GPL
does to this popularity. I don't know. I am just giving you my
opinion. The moment companies learn of something like this, alarm
bells start to go off. This is not rational. I personally have nothing
against open-sourcing all software. *But*, this is not how companies
think.

Let's think about why Linux became so popular and strive towards
keeping it that way instead of resorting to innovative ways of just
confusing a lot of people.

Having said this, I am committed to contribute back to the Linux
community in any way I can, not withstanding my present employer. Keep
up the good work guys!

> DS

vj.
