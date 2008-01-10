Return-Path: <linux-kernel-owner+w=401wt.eu-S1756075AbYAJWDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbYAJWDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 17:03:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbYAJWDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 17:03:05 -0500
Received: from mailout10.sul.t-online.de ([194.25.134.21]:53474 "EHLO
	mailout10.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753212AbYAJWDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 17:03:04 -0500
Message-ID: <4786960D.2040500@t-online.de>
Date: Thu, 10 Jan 2008 23:02:53 +0100
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc7, intel audio: alsa doesn't say a beep
References: <4782833D.3010600@t-online.de>	<s5h3at8rd9c.wl%tiwai@suse.de>	<4783AC7C.50900@t-online.de>	<s5h63y42oy6.wl%tiwai@suse.de>	<478463A6.2070106@t-online.de>	<s5h8x2zo3ox.wl%tiwai@suse.de>	<47852A41.9020903@t-online.de> <s5hr6gpajux.wl%tiwai@suse.de>
In-Reply-To: <s5hr6gpajux.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: rXkuCeZvQhrMjuWMBtd6ZIjRIG-4LHRHQyU63rXXFYmMo1w-P+eOagWiCQ5Lg70gyX
X-TOI-MSGID: 036fd3d3-96ed-4ce0-a76c-ea0ea8aa7f3d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> 
> Hm...  Just to be sure, try the patch below.  It's a clean up patch
> that I'd like to apply later.
> 

Sorry, no sound.

> The perex/alsa.git mm branch on kernel.org has many fixes.  Could you
> give it a try, too?
> 

This version seems to work. But AFAICS it just reverts hda_intel.c back
to rc6 again, so this is no surprise.


Regards

Harri

