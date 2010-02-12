Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676Ab0BLItF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 03:49:05 -0500
Received: from mail-iw0-f201.google.com ([209.85.223.201]:59219 "EHLO
	mail-iw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab0BLItB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 03:49:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=SgDxi/vpI8XYd5wKUyaIte8D9vwa6Pm9qTeOhHcI9LIEJKdMDY0zeHQBiiz/X8iT7A
         9hDJ46zUAoYh08TdHdMMSorsyAJsQwsI1RUnaM1zlkMZF78Kj/wHbbA2fxu7KOU4CMdh
         Y5o47raMwALUG0dpFrOHWYKuj3X6Fb0nlwL9o=
Message-ID: <4B751664.8060603@gmail.com>
Date: Fri, 12 Feb 2010 00:50:44 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
CC: Tomasz Chmielewski <mangoo@wpkg.org>, linux-kernel@vger.kernel.org
Subject: Re: core i7: hang at Booting processor 5 APIC 0x3 ip 0x6000
References: <4B687649.5070204@wpkg.org> <4B687EFF.8000202@gmail.com>	 <4B687F77.5020409@wpkg.org>  <4B6885FA.80509@gmail.com> <1265963139.2484.3.camel@realization>
In-Reply-To: <1265963139.2484.3.camel@realization>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/10 00:25, Alberto Panizzo wrote:
> On mar, 2010-02-02 at 12:07 -0800, Justin P. Mattock wrote:
>> On 02/02/10 11:39, Tomasz Chmielewski wrote:
>>> On 02.02.2010 20:37, Justin P. Mattock wrote:
>>>> apologize for top posting(didn't want to cut dmesg), can this be
>>>> reproduced easily?
>>>> if so are you able to bisect this?
>>>
>>> I can reproduce it every week or so, with several reboots daily.
>>>
>>> Sometimes I can reboot for a few hours in a row, and it boots up
>>> correctly each time.
>>>
>>> So I doubt it's easily bisectable.
>>>
>>>
>>
>> shoot!! you can probably go with the bisect
>> but probably wont hear from you until a month or so(given this takes a
>> week to reproduce).
>> I've been hitting some odd thing here similar to what
>> you have,(stuck during boot right at the CPU*) but probably every
>> two/three months.
>> (from what I've read it seems some cpupowermgmnt.kext thing getting
>> mixed up over here(iMac));
>>
>> Justin P. Mattock
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
> Hi all! In this discussion I can say that Ubuntu kernel 2.6.31-17-generic
> Boots well on my DELL studio 1557 (core i7 powered).
>

lovely...
but what about 2.6.33*(hot off of the press thing).
anyways I've notice something similar
to what you where reporting i.g.
changed over to lilo, and have been hitting some
CPU stuck-age crap during boot hard to
get anything though(will look into when I get a chance).

regards,

Justin P. Mattock
