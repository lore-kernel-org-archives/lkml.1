Return-Path: <linux-kernel-owner+w=401wt.eu-S1760950AbXFBHwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760950AbXFBHwQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 03:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbXFBHwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 03:52:05 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:52216 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754620AbXFBHwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 03:52:04 -0400
Date: Sat, 2 Jun 2007 09:53:57 +0200
From: DervishD <lkml@dervishd.net>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Kernel utf-8 handling
Message-ID: <20070602075357.GB20406@DervishD>
Mail-Followup-To: Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Linux-kernel <linux-kernel@vger.kernel.org>
References: <20070601142058.GA2587@DervishD> <Pine.LNX.4.61.0706012117250.11140@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.61.0706012117250.11140@yvahk01.tjqt.qr>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Jan :)

 * Jan Engelhardt <jengelh@linux01.gwdg.de> dixit:
> On Jun 1 2007 16:20, DervishD wrote:
> >
> >    This said, I know that the console will give me no problems
> >regarding character representantion (heck, I'm pretty sure that I will
> >be able to use even the same font I'm using right now in the console if
> >I get the proper unicode map), but probably will give me problems when
> >*entering* characters. I've read that the kernel handles accented chars,
> >and things like 'ñ' (ntilde) because it assumes that any composed
> >character (composed using dead keys, for example) is in the latin1
> >range. While this is not a perfect behaviour, it will work for me.
> 
> (1) I can do <Compose><~><n> just fine on vt
> (2) I can do <ö> just fine on vt too
> (3) And copy+paste them both using GPM too, again w/o probs

    Cool! :)))

> so not sure where your problem is.

    Right now my only problem was lack of reliable information, but that
has been fully solved by all people who answered, so my next step is to
upgrade kbd and start making tests :))

> I do however have a patch that you could try should a problem arise. I
> should repost and ask around again and beat until it's in :)

    Any patch regarding a better support of utf-8 is very welcome, and I
can help you beat anybody if that will make the patch in XD

    Thanks a lot for the patch (I'll try it if I face problems) and for
your answer.

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
