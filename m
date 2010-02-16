Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab0BPIeg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 03:34:36 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:45020 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754972Ab0BPIef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 03:34:35 -0500
X-Sasl-enc: D3w1sWCGND1k/W5z1BKzQ+Da66sSAjTkCh2G/jxAR0cr 1266309274
Message-ID: <4B7A5899.4000400@ladisch.de>
Date: Tue, 16 Feb 2010 09:34:33 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Sebastien Alaiwan <sebastien.alaiwan@gmail.com>
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH][ALSA] usbmidi support for Access Music synths.
References: <4B726306.8070506@gmail.com> <4B7274BA.3040801@ladisch.de> <4B73B96A.9040006@gmail.com> <4B73C3EC.2040606@ladisch.de> <4B745D00.5060201@gmail.com> <4B751E34.1000703@ladisch.de> <4B7A4BEF.1030005@gmail.com>
In-Reply-To: <4B7A4BEF.1030005@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastien Alaiwan wrote:
> Clemens Ladisch wrote:
>> Sebastien Alaiwan wrote:
>>> How can I inform the
>>> snd-usb-audio driver that the USB interface 4 should be left alone?
>> 
>> With a QUIRK_IGNORE_INTERFACE for that interface.  This means you need
>> QUIRK_COMPOSITE again.
> 
> Ok, this is done.
> Here's an updated patch.

Applied; thanks!


Clemens
