Return-Path: <linux-kernel-owner+w=401wt.eu-S935495AbYEBP1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935495AbYEBP1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 11:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763762AbYEBP0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 11:26:51 -0400
Received: from mail.hauppauge.com ([167.206.143.4]:2314 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765112AbYEBP0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 11:26:50 -0400
Message-ID: <481B32AE.10606@linuxtv.org>
From: mkrufky@linuxtv.org
To: stoth@linuxtv.org
Cc: gorcunov@gmail.com, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org, mchehab@infradead.org
Subject: Re: [v4l-dvb-maintainer] build bug - cx23885
Date: Fri, 2 May 2008 11:26:38 -0400 
MIME-Version: 1.0
X-Mailer: Internet Mail Service (5.5.2657.72)
in-reply-to: <481B2B90.6060508@linuxtv.org>
x-originalarrivaltime: 02 May 2008 15:23:12.0667 (UTC) FILETIME=[6F7676B0:01C8AC68]
user-agent: Thunderbird 2.0.0.12 (Windows/20080213)
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Toth wrote:
> Cyrill Gorcunov wrote:
>   
>> Not sure if it fixed recently - but from today morning sync'ed git
>>
>> Kernel: arch/x86/boot/bzImage is ready  (#61)
>> Building modules, stage 2.
>>  MODPOST 773 modules
>>  ERROR: "dib7000p_attach" [drivers/media/video/cx23885/cx23885.ko]
undefined!
>>  make[1]: *** [__modpost] Error 1
>>  make: *** [modules] Error 2
>>
>> .config attached
>>     
>
> Thanks Cyrill, I'll look into this.
>
> Regards,
>
> Steve
I fixed this already, the fix is already in Mauro's git tree, and he's 
already asked Linus to merge it (I don't think Linus merged it yet)

-Mike
