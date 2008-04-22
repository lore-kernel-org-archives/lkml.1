Return-Path: <linux-kernel-owner+w=401wt.eu-S1761468AbYDVQmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761468AbYDVQmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 12:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755095AbYDVQmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 12:42:37 -0400
Received: from mail.AKNET.ru ([77.246.241.226]:58054 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354AbYDVQmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 12:42:36 -0400
Message-ID: <480E156B.3010809@aknet.ru>
Date: Tue, 22 Apr 2008 20:42:19 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: Re: 2.6.25-mm1 (snd-pcsp doesn't like DEBUG_PAGEALLOC)
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org> <20080419021343.GA3503@nineveh.local> <20080418200237.b5a9e805.akpm@linux-foundation.org> <20080419041429.GA8508@anvil.corenet.prv> <20080418212934.bbe84ee2.akpm@linux-foundation.org> <s5h8wz7cng7.wl%tiwai@suse.de> <480CD50F.20706@aknet.ru> <s5hbq42b3j7.wl%tiwai@suse.de> <20080422084401.ZZRA012@mailhub.coreip.homeip.net>
In-Reply-To: <20080422084401.ZZRA012@mailhub.coreip.homeip.net>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Dmitry Torokhov wrote:
> Just out of curiosity, what is the sound quality with the PC speaker?
That depends on the speaker itself.
If it is large enough (not a piezo
tablet), then the sound probably
matches the telephone. :)

> Not to belittle Stas's effort, but how relevant is this driver for
> mainline given that it os pretty much impossible nowadays to find a
> motherboard without on-board sound?
I know it is used because people are
mailing me about it. Mainly on servers
I think, as on a desktop its value it
really questionable. :)
The real problem is that the board
manufacturers put the piezo beepers
these days, and also nvidia already
excluded the necessary capabilities
from their NForce chipset. So in the
future it may indeed became out of
the use.
By the way, you may be surprised, but
I am still being asked by various people
to write an LPT DAC (Covox) sound driver
(the ancient OSS-based pc-speaker driver
supported also that).
I guess people just like to use all
the hardware they have, even if it is
not really very usefull.
