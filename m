Return-Path: <linux-kernel-owner+w=401wt.eu-S1758316AbYLFON5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758316AbYLFON5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 09:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756080AbYLFONt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 09:13:49 -0500
Received: from mailout01.t-online.de ([194.25.134.80]:33618 "EHLO
	mailout01.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575AbYLFONt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 09:13:49 -0500
Message-ID: <493A8854.5000805@t-online.de>
Date: Sat, 06 Dec 2008 15:12:36 +0100
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Jordan Crouse <jordan@cosmicpenguin.net>
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27.7 built for Geode: Clock drift
References: <49358017.7080009@t-online.de> <493961EE.6000002@cosmicpenguin.net>
In-Reply-To: <493961EE.6000002@cosmicpenguin.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: Ewo7BvZBwhLucK0AJSNSKONOCeCS-s6jDc+5yWbFiUy04wbW-uFI15-pdXJcBEmQcQ
X-TOI-MSGID: fed16f12-cc8d-4668-bf82-d5248691b109
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jordan,

Jordan Crouse wrote:
> 
> Hmm - we've heard reports of this before, but nothing came of it.  I 
> would be interested in a chance to debug it this time.
> 
> Please try turning off CONFIG_GEODE_MFGPT_TIMER=y and try again.  Also, 
> try something in the 2.6.28 family to rule out fixes in the timer 
> subsystem.
> 
> Thanks,
> Jordan
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Dipl.-Ing. Harald Dunkel     | "They that can give up liberty to obtain
Muehlenbachstr. 3            | a little temporary safety deserve neither
52134 Herzogenrath, Germany  | liberty nor safety."
+49 2407 565 105             |            Benjamin Franklin, 1706 - 1790
