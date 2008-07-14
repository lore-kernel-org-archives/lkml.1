Return-Path: <linux-kernel-owner+w=401wt.eu-S1757479AbYGNRU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479AbYGNRU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 13:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754397AbYGNRUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 13:20:19 -0400
Received: from gw.goop.org ([64.81.55.164]:36740 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626AbYGNRUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 13:20:18 -0400
Message-ID: <487B8AC5.2010503@goop.org>
Date: Mon, 14 Jul 2008 10:20:05 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: next-0710: CONFIG_PARAVIRT broken on x86_64?
References: <s5htzexryqy.wl%tiwai@suse.de>	<487621BC.4040001@goop.org>	<s5hmykprv2q.wl%tiwai@suse.de>	<48765CCD.4070308@goop.org>	<s5hlk08rgv8.wl%tiwai@suse.de>	<48766D17.9000704@goop.org>	<s5hhcavxy3f.wl%tiwai@suse.de> <s5hod4ywnba.wl%tiwai@suse.de>
In-Reply-To: <s5hod4ywnba.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> This seems fixed on linux-next-20080714 magically.
> Thanks for your help, anyway!

Yes, I couldn't reproduce it, but there were some fixes for bugs with 
similar symptoms.

Thanks very much for reporting back,
    J

