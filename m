Return-Path: <linux-kernel-owner+w=401wt.eu-S1758986AbXHBQSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758986AbXHBQSw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 12:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758827AbXHBQSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 12:18:42 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:41058 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758804AbXHBQSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 12:18:40 -0400
Message-ID: <46B203D8.5050405@interia.pl>
Date: Thu, 02 Aug 2007 18:18:32 +0200
From: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 2.0.0.5 (X11/20070720)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ash Willis <ashwillis@programmer.net>, linux-kernel@vger.kernel.org,
       tiwai@suse.de
Subject: Re: CS5530 Alsa driver fails
References: <20070801174103.D03341F50B1@ws1-2.us4.outblaze.com>	<46B0D628.3050409@interia.pl> <20070801230812.6f28bad0@the-village.bc.nu>
In-Reply-To: <20070801230812.6f28bad0@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-EMID: d0196acc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The 5530 in native mode only generates SMI. I've always felt however that
> if you make the buffers big enough you ought to be able to drive it off
> the 1KHz timer tick by polling. Interesting project.
Looks like somebody did it already. I will try it as soon as  I can.
> You btw won't have removed the SMM firmware or the box wouldn't boot. The
> 5530 uses SMM to emulate some of the most basic PC components including
> the VGA video. 
Hmm. I don't have VGA. Linux was always starting without VGA console. I had 
to disable display (power off the DAC's) because of constant "Checking FLASH" 
screen.
 
> Alan
Rafa³


----------------------------------------------------------------------
Sprawdz
czy Ty i Twoj partner pasujecie do siebie emocjonalnie i seksualnie

>>>http://link.interia.pl/f1b14

