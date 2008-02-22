Return-Path: <linux-kernel-owner+w=401wt.eu-S1764199AbYBVUO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764199AbYBVUO2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 15:14:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757106AbYBVUOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 15:14:07 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:60336 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302AbYBVUOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 15:14:05 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Date: Fri, 22 Feb 2008 21:12:44 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Alexey Zaytsev" <zaytsev.a@protei.ru>, "Greg KH" <greg@kroah.com>,
       linux-kernel@vger.kernel.org
References: <47BEAF3B.3080809@protei.ru> <200802221848.37902.mb@bu3sch.de> <f19298770802221206j4d56f002mc4c2036842a18f58@mail.gmail.com>
In-Reply-To: <f19298770802221206j4d56f002mc4c2036842a18f58@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802222112.44317.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 February 2008 21:06:00 Alexey Zaytsev wrote:
> >  It is not my problem, if you refuse to use b43.
> >  You also still refuse to tell me details about your card and _what_
> >  does not work. I do own lots of different card and they
> >  all work fine with b43. There's one exception, the 4311 rev 3 (or something,
> >  don't quite remember). But patches are available and will ship in 2.6.25.
> >  bcm43xx won't get removed until that shipped.
> 
> Yes, it's a 4311 rev 01, but I'm probably was just too lame to upgrade the
> firmware or something. :E
> 
> I really don't get it, what is going on here? You state that the new b32 driver
> has problems on some hardware, where the old bcm43xx driver just works.
> And at the same time, you are surprised that I "refuse" to use the b43 driver
> and push patches for the bcm43xx driver you broke... Oh, really, why?!

So, please find someone who will sign-off your patch. I won't.
What's so hard to understand about that? Do I _have_ to sign off all patches
random people send to me?
I do _not_ want to be made responsible for that patch by signing it off.
It is as simple as that.
And I officially do not care about bcm43xx since a year and a half anymore.
So why should I ACK it or sign it off?

-- 
Greetings Michael.
