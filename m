Return-Path: <linux-kernel-owner+w=401wt.eu-S1753521AbZKDBeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbZKDBeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 20:34:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbZKDBeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 20:34:08 -0500
Received: from mail-iw0-f180.google.com ([209.85.223.180]:34014 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbZKDBeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 20:34:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=E/mJ2I2RL/A3Cy6J5bqnTrj/7sNOHgQIKoagD6itUu9kEkgSUPzfvxIOU/Owqczamt
         nq5oJIIW8VkE4XIb4D5Ghq3aPnBcb1ubgpMdcy73d6lfJS/ld9mgiP27gkpgh+iwef9A
         E9Ei2QD4avtVYC26+Ut7nHX7Wcf6kM4Donu7U=
MIME-Version: 1.0
In-Reply-To: <200911040046.54247.bzolnier@gmail.com>
References: <200911031951.05235.bzolnier@gmail.com> <200911032334.40547.bzolnier@gmail.com> 
	<14add3d10911031509l328e7674kb625b70250ff30fb@mail.gmail.com> 
	<200911040046.54247.bzolnier@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 4 Nov 2009 12:33:52 +1100
Message-ID: <646765f40911031733u1641c0dr5d4eec30031e7cea@mail.gmail.com>
Subject: Re: [announce] new rt2800 drivers for Ralink wireless & project tree
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
       Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Luis Correia <luis.f.correia@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Ingo Molnar <mingo@elte.hu>, Johannes Berg <johannes@sipsolutions.net>,
       Jarek Poplawski <jarkao2@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 4, 2009 at 10:46, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
>> If you just want to continue with a hostile take-over of the rt2800
>> maintainership, then please
>> let us know that, so that we stop spending time on useless
>
> I fail to see why you see it as a hostile takeover.

Updating MAINTAINERS to replace the current developers with yourself
can be considered to be a hostile act.

If you want this for your own personal tree, then keep the patch
private - don't include it in pull requests, patch listings etc.

And if you genuinely want the maintainership of the rt28xx drivers,
then updating MAINTAINERS should be done as an afterthought after
clearly proving that you are capable of maintaining the driver and
working with the maintainers of the rt2x00 and wireless subsystems.

> I will be glad to cooperate with you or anyone else from rt2x00 project.
> However I will not spin in some stupid bureaucracy when I see that things
> can be done more effectively.

It's not "stupid bureaucracy" it's *how* *it's* *done*.

If I was going to submit a patch to the Marvell TOPDOG driver to add
support for another related chipset, I'd be going out of my way to
make sure that *everyone* involved was 100% happy so that the patch
can get out to the people who matter: the users.

Everyone has to do this, from big corporations like Intel, to you and
me. For example, I recall the Intel IWL developers being smacked down
a few months ago by John and David over exactly what constitutes a
post-merge window "bugfix".

The rules apply to everyone, just because you don't like them doesn't
mean you can ignore them.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: http://sites.google.com/site/juliancalaby/
