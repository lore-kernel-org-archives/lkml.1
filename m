Return-Path: <linux-kernel-owner+w=401wt.eu-S1760616AbXFBHli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760616AbXFBHli (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 03:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755886AbXFBHlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 03:41:32 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:61087 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755278AbXFBHlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 03:41:31 -0400
Date: Sat, 2 Jun 2007 09:43:21 +0200
From: DervishD <lkml@dervishd.net>
To: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Kernel utf-8 handling
Message-ID: <20070602074321.GB20145@DervishD>
Mail-Followup-To: "Alexander E. Patrakov" <patrakov@ums.usu.ru>,
	Linux-kernel <linux-kernel@vger.kernel.org>
References: <20070601142058.GA2587@DervishD> <46604928.4050002@ums.usu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46604928.4050002@ums.usu.ru>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Alexander :)

 * Alexander E. Patrakov <patrakov@ums.usu.ru> dixit:
> >    I have a do-it-yourself Linux box, and I'm planning to move to UTF8
> >(currently I'm using es_ES locale, with latin1 encoding). One of my main
> >concerns (apart from programs with little or no utf8 support, which I
> >will have to suffer) is kernel handling, because I only use the console;
> >I only use X and a terminal emulator if I can't avoid it.
> 
> The switch is possible.

    The switch to utf-8 is possible, I know, but I wasn't so sure about
the switch to utf-8 *in the console only*.

> You could try the latest development LFS LiveCD
> (http://ums.usu.ru/~patrakov/test/lfslivecd-x86-6.3-pre2-r1897.iso)
> and see if it works for you (be sure to CC: me if you post any
> feedback). It will automatically configure the console using a simple
> menu-driven interface. Some interesting programs to try there: mutt,
> tin, lynx, finch.

    I was going to take a look at Linux From Scratch (and BLFS, too) for
help, but before trying anything there I wanted to be sure that the
kernel will work. Otherwise I will put my effort in building a minimal X
setup with a suitable terminal emulator.

    Anyway, if everything works in the console in the LFS LiveCD, I will
be sure that I can make the change and then I'll look directly in the
LFS book for further instructions.

    Thanks a lot! :)

> >    Will the console work as it works now if I can live with latin1
> >accented characters only? Is there any terminal emulator *for the
> >console*, not for X, that handles utf8? Will I be sentenced to X to be
> >able to use my computer with utf8?
> 
> screen,

    GNU screen? I'll give it a try.

> jfbterm, iterm (jfbterm and iterm are not on my CD, but you can 
> build them from source there - the filesystem on the CD can be written to). 

    There are more terminal emulators for console than I supposed.

> Note that jfbterm and iterm expect X fonts (or unifont) to be available, 
> and the CD doesn't have these fonts (fully switched to Xft).

    Well, I'll deal with that issue if I like them more than screen or
plain console.

    Thanks again :)

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
