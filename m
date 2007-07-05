Return-Path: <linux-kernel-owner+w=401wt.eu-S1757839AbXGEFZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839AbXGEFZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 01:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754607AbXGEFZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 01:25:10 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:32998 "EHLO
	asav06.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384AbXGEFZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 01:25:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkchAE0djEZKhRO4R2dsb2JhbACHJod6AQEbDQYRAQ
From: Dmitry Torokhov <dtor@insightbb.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: blink driver power saving
Date: Thu, 5 Jul 2007 01:25:05 -0400
User-Agent: KMail/1.9.3
Cc: Andi Kleen <ak@suse.de>, Indan Zupancic <indan@nul.nu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       bwalle@suse.de
References: <51563.81.207.0.53.1183376603.squirrel@secure.samage.net> <d120d5000707020643y1b4f03ebid0ae37adb40d0a53@mail.gmail.com> <20070704214738.GA1685@elf.ucw.cz>
In-Reply-To: <20070704214738.GA1685@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707050125.06638.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 July 2007 17:47, Pavel Machek wrote:
> Hi!
> 
> > >I was thinking about something like the atached (untested and sorry
> > >for using attachment). It shoudl blink just one led (numLock) on any
> > >keyboard that has such LED (and allows to control it).
> > >
> > 
> > Argh, bad one. This one shoudl be better.
> 
> Does it blink for you? It does not seem to do anything here :-(.

Yes it does. Just tested it and it blinks NumLock led just fine.

-- 
Dmitry
