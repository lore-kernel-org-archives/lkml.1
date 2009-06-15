Return-Path: <linux-kernel-owner+w=401wt.eu-S933344AbZFOSDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933344AbZFOSDj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932340AbZFOSAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:00:33 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:54798 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932181AbZFOSAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:00:31 -0400
Message-ID: <4A368C3F.6080105@msgid.tls.msk.ru>
Date: Mon, 15 Jun 2009 22:00:31 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: linux-kernel@vger.kernel.org
Subject: Re: PC speaker beeps in 2.6.30?
References: <4A365DA6.8000102@msgid.tls.msk.ru> <200906151857.36576.elendil@planet.nl>
In-Reply-To: <200906151857.36576.elendil@planet.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> Michael Tokarev wrote:
>> Anyone know what happened with PC speaker in 2.6.30?
>> Basically, it does not work anymore here, with the
>> config which is very similar to the one used for
>> previous 2.6.29 kernel (where PC speaker worked).
>> At least I don't see any relevant differences and
>> the (seemengly) relevant symbols -- which are
>> INPUT_PCSPKR and PCSPKR_PLATFORM -- are both set
>> to 'y' for both 2.6.29 and 2.6.30.
> 
> For me the system beep has been replaced by a beep in ALSA with .30.

Hmm...

> Do you have soundcard that uses HDA? Is CONFIG_SND_HDA_INPUT_BEEP set?
> Does alsamixer show a "beep" control? Is that not muted and does it have 
> volume set?

..Yes there is such a control and yes it is muted.  When un-muting it I do
hear an ugly/scary beep from my soundcard (from the speakers).  But I don't
have anything connected to the soundcard on any of my servers.

On a similar motherboard with 2.6.29 I've a "PC Speak" control which does
not do anything, at least not visible (or audible).

But I'd rather get my old good pc speaker back.  One thing is the sound
card with speakers which are only sometimes on and which produces very
very bad sound when the 'beeper' control is turned on, and another is the
old good PC internal speaker with a good "beep" sound.

Thanks!

/mjt
