Return-Path: <linux-kernel-owner+w=401wt.eu-S1761223AbXGEUU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761223AbXGEUU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 16:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757909AbXGEUUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 16:20:17 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:20221 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872AbXGEUUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 16:20:16 -0400
Message-ID: <468D527D.5000809@msgid.tls.msk.ru>
Date: Fri, 06 Jul 2007 00:20:13 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: VIA C7 / VIA PC-1 (PC2500) anyone?
References: <466E65A7.3000206@msgid.tls.msk.ru>
In-Reply-To: <466E65A7.3000206@msgid.tls.msk.ru>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev wrote:
> I bought a VIA PC2500 board a few days ago - this
> new series of their mobos,
> 
[]
> It works generally - it boots, I can run my usual apps
> etc.  But on a random (yet frequent) basis it segfaults
> here and there.  For example:

Replying to my old message.  Yes the mobo crashed like
crazy and was very unstable.  I returned it back to the
store and got a replacement, exactly the same thing.
Which, unlike the previous one, works flawlessly so
far - at least I can't reproduce any crashes anymore.
More -- CPU temperature, which - according to the
lm_sensors values, was jumping somewhere between
40C and 65C, is now at 24C at idle and 35C under
high load.  CPU headsink is MUCH cooler on this
mobo, while the fan is working exactly the same.
And no more themp jumps as before.  So it turns out
I just had a bad (defected) mobo, nothing to do with
kernel....  Oh well.

(But BIOS on this mobo is a bit crappy still.  Not
fatal but not nice either.)

/mjt
