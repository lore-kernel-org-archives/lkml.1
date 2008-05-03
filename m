Return-Path: <linux-kernel-owner+w=401wt.eu-S1760977AbYECMm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760977AbYECMm2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 08:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755567AbYECMmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 08:42:19 -0400
Received: from hu-out-0506.google.com ([72.14.214.238]:51066 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519AbYECMmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 08:42:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=NRD0ADUNINByFC3Ol3UDtr6nCWqObsufdOO3sM3Y7esvO59Tb8ztm6pzuRmUAD7Yd0bmW9dC0tCVrbhxYlDxV1t9mFk8UjW2B90Cgkw+jZFiT9fmP78lCDQf8e04nE+3NQfNZmG5HOiJsnFLKbA4l+rKNubGOqe4BIeQITY+rUQ=
Date: Sat, 3 May 2008 16:41:27 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Steven Toth <stoth@linuxtv.org>
Cc: mkrufky@linuxtv.org, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org, mchehab@infradead.org
Subject: Re: [v4l-dvb-maintainer] build bug - cx23885
Message-ID: <20080503124127.GE6844@cvg>
References: <481B32AE.10606@linuxtv.org> <481B34E5.5010007@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481B34E5.5010007@linuxtv.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Steven Toth - Fri, May 02, 2008 at 11:36:05AM -0400]
> mkrufky@linuxtv.org wrote:
>> Steven Toth wrote:
>>> Cyrill Gorcunov wrote:
>>>   
>>>> Not sure if it fixed recently - but from today morning sync'ed git
>>>>
>>>> Kernel: arch/x86/boot/bzImage is ready  (#61)
>>>> Building modules, stage 2.
>>>>  MODPOST 773 modules
>>>>  ERROR: "dib7000p_attach" [drivers/media/video/cx23885/cx23885.ko]
>> undefined!
>>>>  make[1]: *** [__modpost] Error 1
>>>>  make: *** [modules] Error 2
>>>>
>>>> .config attached
>>>>     
>>> Thanks Cyrill, I'll look into this.
>>>
>>> Regards,
>>>
>>> Steve
>> I fixed this already, the fix is already in Mauro's git tree, and he's 
>> already asked Linus to merge it (I don't think Linus merged it yet)
>
> Thanks, I don't think I saw that post.
>
> - Steve
>

Thanks

		- Cyrill -
