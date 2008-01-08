Return-Path: <linux-kernel-owner+w=401wt.eu-S1756344AbYAHRbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344AbYAHRbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 12:31:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbYAHRa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 12:30:57 -0500
Received: from mailout09.sul.t-online.de ([194.25.134.84]:34299 "EHLO
	mailout09.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751203AbYAHRa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 12:30:56 -0500
Message-ID: <4783AC7C.50900@t-online.de>
Date: Tue, 08 Jan 2008 18:01:48 +0100
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc7, intel audio: alsa doesn't say a beep
References: <4782833D.3010600@t-online.de> <s5h3at8rd9c.wl%tiwai@suse.de>
In-Reply-To: <s5h3at8rd9c.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: T-EpCuZ-8h0k0i2dY-4Kr5wyAFKovObZ7yoKG7GnvZZwXwNxowKw3m4WZnEUY8jZzp
X-TOI-MSGID: 0af522aa-1971-40dc-8ae8-168d6c9ac4be
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Takashi-san,

Takashi Iwai wrote:
> 
> Could you revert it and check whether the problem still exists?
> 

I did, and sound is back :-).

Please mail, if you need the .config file. BTW, I missed to send
the output of uname. Here is:

Linux daffy 2.6.24-rc7 #1 SMP Tue Jan 8 07:17:39 CET 2008 x86_64 GNU/Linux

Its 64bit.


Regards

Harri

