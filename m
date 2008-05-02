Return-Path: <linux-kernel-owner+w=401wt.eu-S935130AbYEBPgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935130AbYEBPgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 11:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759942AbYEBPgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 11:36:14 -0400
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196]:42307 "EHLO
	mta1.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756488AbYEBPgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 11:36:13 -0400
Date: Fri, 02 May 2008 11:36:05 -0400
From: Steven Toth <stoth@linuxtv.org>
Subject: Re: [v4l-dvb-maintainer] build bug - cx23885
In-reply-to: <481B32AE.10606@linuxtv.org>
To: mkrufky@linuxtv.org
Cc: gorcunov@gmail.com, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org, mchehab@infradead.org
Message-id: <481B34E5.5010007@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <481B32AE.10606@linuxtv.org>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mkrufky@linuxtv.org wrote:
> Steven Toth wrote:
>> Cyrill Gorcunov wrote:
>>   
>>> Not sure if it fixed recently - but from today morning sync'ed git
>>>
>>> Kernel: arch/x86/boot/bzImage is ready  (#61)
>>> Building modules, stage 2.
>>>  MODPOST 773 modules
>>>  ERROR: "dib7000p_attach" [drivers/media/video/cx23885/cx23885.ko]
> undefined!
>>>  make[1]: *** [__modpost] Error 1
>>>  make: *** [modules] Error 2
>>>
>>> .config attached
>>>     
>> Thanks Cyrill, I'll look into this.
>>
>> Regards,
>>
>> Steve
> I fixed this already, the fix is already in Mauro's git tree, and he's 
> already asked Linus to merge it (I don't think Linus merged it yet)

Thanks, I don't think I saw that post.

- Steve
