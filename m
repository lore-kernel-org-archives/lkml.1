Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab0BBUGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 15:06:00 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:46117 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464Ab0BBUF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 15:05:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=hAlwYYsSLE2dUTdfDno+160L+zLSyAfwi2/mWpoiEoNjkNVAoqTYW9lSexDZ1y9Zl0
         ZDGGRUt/ZXt+RPSi5kQndtWm/rD0quLY9RfpbC9gAvLQufhl3guriTGUkjQwbGmjhr74
         9/fyVbkEwFdYK7oQWtYkI9m/mAzmPIQEDQhRU=
Message-ID: <4B6885FA.80509@gmail.com>
Date: Tue, 02 Feb 2010 12:07:22 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Tomasz Chmielewski <mangoo@wpkg.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: core i7: hang at Booting processor 5 APIC 0x3 ip 0x6000
References: <4B687649.5070204@wpkg.org> <4B687EFF.8000202@gmail.com> <4B687F77.5020409@wpkg.org>
In-Reply-To: <4B687F77.5020409@wpkg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/10 11:39, Tomasz Chmielewski wrote:
> On 02.02.2010 20:37, Justin P. Mattock wrote:
>> apologize for top posting(didn't want to cut dmesg), can this be
>> reproduced easily?
>> if so are you able to bisect this?
>
> I can reproduce it every week or so, with several reboots daily.
>
> Sometimes I can reboot for a few hours in a row, and it boots up
> correctly each time.
>
> So I doubt it's easily bisectable.
>
>

shoot!! you can probably go with the bisect
but probably wont hear from you until a month or so(given this takes a 
week to reproduce).
I've been hitting some odd thing here similar to what
you have,(stuck during boot right at the CPU*) but probably every 
two/three months.
(from what I've read it seems some cpupowermgmnt.kext thing getting 
mixed up over here(iMac));

Justin P. Mattock
