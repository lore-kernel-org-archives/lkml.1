Return-Path: <linux-kernel-owner+w=401wt.eu-S1752762AbYIQNMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbYIQNMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 09:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbYIQNMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 09:12:01 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:56304 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbYIQNL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 09:11:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AAQHyepUpsV/xEbWm9tfQtQuP9B3DuXnHZBLAvy8QqUMO+u4n3mU3o9LdpuMN4LtnB
         Hbg8YT4HnioV92hXCakjJ5+eruMVZM7QFrQWKSjpl4MwF9jRThLLH3Wq3zktfHu+MjnC
         noYfHA5cEipURsvJ/30JanhsTXqnbdSB9BJuY=
Message-ID: <48D0BBCA.2070204@gmail.com>
Date: Wed, 17 Sep 2008 03:11:54 -0500
From: Benny Halevy <bhalevy.lists@gmail.com>
User-Agent: Thunderbird 3.0a1 (X11/2008050714)
MIME-Version: 1.0
To: Bily <hsssss1111@163.com>
CC: mal reddy y <malreddy.linux@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: insmod problem
References: <200809161515454846111@163.com>, <25136850809170119p2ea954ek6ece0c847dfa5823@mail.gmail.com> <200809171627292035857@163.com>
In-Reply-To: <200809171627292035857@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you please provide your .config file?
I'm mostly curious about
CONFIG_MODVERSIONS
CONFIG_MODULE_FORCE_LOAD

Benny

On Sep. 17, 2008, 3:27 -0500, "Bily" <hsssss1111@163.com> wrote:
> I am installing the linux kernel 2.6.26.2 to my AT91rm9200;I compile the kernel by using cross compiler  arm-none-eabi-gcc (Sourcery G++ Lite 2008q1-126); and the kernel can run on AT91rm9200 normally;howerver if i want to insert modules into kernel ,it happen the mistake like this:
> 
> [\u@\h \W]$insmod yaffs.ko
> yaffs: unknown relocation: 40
> insmod: cannot insert 'yaffs.ko': invalid module format
> 
> thanks for help!~
> 
> 
> 
> 
> 
> Bily
> 2008-09-17
> 
> 
> 
> 发件人： mal reddy y
> 发送时间： 2008-09-17 16:19:52
> 收件人： Bily
> 抄送： linux-kernel
> 主题： Re: insmod problem
> 
> give clear explanation how you have installed
> 
> regards,
> YMR
> 
> On Tue, Sep 16, 2008 at 12:45 PM, Bily  <hsssss1111@163.com > wrote:
>> hi,all;
>>    I want to insert an module:yaffs.ko into my kernel2.6.26,but i meet this question:
>>
>> [\u@\h \W]$insmod yaffs.ko
>> yaffs: unknown relocation: 40
>> insmod: cannot insert 'yaffs.ko': invalid module format
>>
>> and my busybox version is v1.11.1; may anyone tell me why ?thanks!
>>
>>
>> Bily
>> 2008-09-13
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> N嫥叉靣笡y氊b瞂千v豝�)藓{.n�+壏{睉赙zXФ洝塄}财爖�&j:+v墾�珣赙zZ+€�+zf＂穐殘啳嗃i�z�畐ア�?櫒璀�&�)撷f旟^j谦y呩@A玜囤�0鹅h�鍜i

