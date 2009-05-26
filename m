Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192AbZEZILH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbZEZILH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 04:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbZEZIKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 04:10:55 -0400
Received: from luminismail.carleton.ca ([134.117.2.27]:36948 "EHLO
	luminismail.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbZEZIKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 04:10:54 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=US-ASCII
Message-id: <4A1BA409.6040804@superonline.com>
Date: Tue, 26 May 2009 04:10:49 -0400
From: "M. Vefa Bicakci" <bicave@superonline.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
To: linux-kernel@vger.kernel.org
Subject: Re: [Bisected regression] Microphone no longer works on Toshiba
 Satellite A100
References: <4A196CF5.8010504@superonline.com> <s5hskiuv4d2.wl%tiwai@suse.de>
 <4A198CAD.6090109@superonline.com> <s5hk545d8sc.wl%tiwai@suse.de>
In-reply-to: <s5hk545d8sc.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I just wanted to let everyone else know that I have tested the
patch Takashi Iwai provided, and that the microphone works properly
with the patch applied.

Below is our conversation, which I forgot to Cc: to LKML.

Thanks everyone,

M. Vefa Bicakci

> -------- Original Message --------
> Subject: Re: [Bisected regression] Microphone no longer works on Toshiba Satellite A100
> Date: Tue, 26 May 2009 07:49:41 +0200
> From: Takashi Iwai <tiwai@suse.de>
> To: M. Vefa Bicakci <bicave@superonline.com>
> References: <4A196CF5.8010504@superonline.com>	<s5hskiuv4d2.wl%tiwai@suse.de>	<4A198CAD.6090109@superonline.com>	<s5hk545d8sc.wl%tiwai@suse.de>	<4A1B10D5.9000009@superonline.com>
> 
> At Mon, 25 May 2009 17:42:45 -0400,
> M. Vefa Bicakci wrote:
>> 
>> Takashi Iwai wrote:
>> >>> [snip]
>> > Thanks.  Does the patch below work?
>> 
>> Yes, I just tried it by compiling alsa-driver-1.0.20 after applying
>> the patch you provided, and I can happily say that it works beautifully.
>> 
>> Thank you so much! I really hope that this patch will be included in
>> the next ALSA release and the next -rc release for 2.6.30.
> 
> I merged now it to sound git tree and will include in the next pull
> request.
> 
> Thanks for testing!
> 
> 
> Takashi



