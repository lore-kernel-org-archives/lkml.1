Return-Path: <linux-kernel-owner+w=401wt.eu-S1757182AbYGJUMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182AbYGJUMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 16:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755798AbYGJUMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 16:12:20 -0400
Received: from gw.goop.org ([64.81.55.164]:33233 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755795AbYGJUMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 16:12:20 -0400
Message-ID: <48766D17.9000704@goop.org>
Date: Thu, 10 Jul 2008 13:12:07 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: next-0710: CONFIG_PARAVIRT broken on x86_64?
References: <s5htzexryqy.wl%tiwai@suse.de>	<487621BC.4040001@goop.org>	<s5hmykprv2q.wl%tiwai@suse.de>	<48765CCD.4070308@goop.org> <s5hlk08rgv8.wl%tiwai@suse.de>
In-Reply-To: <s5hlk08rgv8.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> Native.  Booted on a HP machine with two Intel x86-64 CPUs.
>   

Is that the complete log of what it prints out?  Does it print any 
addresses or anything?

Could you try tip.git with the config to see if its there?  I don't 
think there should be anything relevent in -next, but there could be a 
merge problem or something.

Does booting with "init=/bin/sh" make any progress?

    J
