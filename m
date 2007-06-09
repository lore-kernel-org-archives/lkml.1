Return-Path: <linux-kernel-owner+w=401wt.eu-S1754347AbXFIJa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbXFIJa0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 05:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751030AbXFIJaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 05:30:18 -0400
Received: from cb2.northrockquote.com ([64.251.14.146]:2769 "EHLO
	dejavu.debianpt.org" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbXFIJaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 05:30:16 -0400
Message-ID: <466A7321.4060304@debianpt.org>
Date: Sat, 09 Jun 2007 10:30:09 +0100
From: Miguel Figueiredo <elmig@debianpt.org>
Organization: DebianPT.org
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Celso <celsopr@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: -ck patch | Feedback
References: <1181341039.28846.0.camel@localhost>
In-Reply-To: <1181341039.28846.0.camel@localhost>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Celso wrote:
> Hello, I'm using -ck since... along time ago (I start using it with the
> kernel 2.6.16) . I started using it with Ubuntu and  the response of the
> system  was better. Since that I always compile my kernels with -ck.
> Actually I use 2.6.20-ck1 and I have no problems, even with things that
> needs kernel-sources like gspca for my webcam.
> 
> Thanks a lot for the patches. 
> 
> PS: when will this go into the official kernel?
> 

Hi there,

  have you tryied a newer kernel with -ck2 [1] ?

I am also using a -ck patch, 2.6.21-ck2, mostly on 2 machines where i
use as desktop and also play games. With -ck2 the experience seems less
slugish and more smooth while playing 'second life' and have a bunch of
other programs open (mail, a zillion web pages, irc client, feed reader,
consoles, ...).
The desktop seems more confortable to use than with the vanilla kernel.
I also tryed cfs, it's also much better than the vanilla kernel but i
still prefer -ck2 for playing second life as it feels more responsive.


If you try the -ck2 or SD 1.0 please report your experience. It's nice
to hear that people are testing/using these improvements on desktop usage.



1 - ck2 patch to add to vanilla 2.6.21,
http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.21/2.6.21-ck2/patch-2.6.21-ck2.bz2

PS: I remember i read somewhere that the SD patch (included in -ck) has
became stable (version 1.0) with a few small improvements!

-- 

Com os melhores cumprimentos/Best regards,

Miguel Figueiredo
http://www.DebianPT.org
