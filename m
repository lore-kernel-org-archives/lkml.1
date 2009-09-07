Return-Path: <linux-kernel-owner+w=401wt.eu-S1753172AbZIGLyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbZIGLyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 07:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbZIGLyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 07:54:31 -0400
Received: from mailout5.samsung.com ([203.254.224.35]:49373 "EHLO
	mailout5.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbZIGLyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 07:54:31 -0400
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Sep 2009 07:54:30 EDT
Date: Mon, 07 Sep 2009 20:44:30 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: haptics devices linux driver support
In-reply-to: <5d5443650909070429q1eeb5b78t8398ba670143fbf9@mail.gmail.com>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: Kyungmin Park <kmpark@infradead.org>, Jiri Slaby <jirislaby@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Message-id: <4AA4F21E.5080400@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
References: <5d5443650908221004y5b893382m368dc18a38636c1b@mail.gmail.com>
 <4A902904.2090008@gmail.com>
 <9c9fda240908222145j1938baa3v3ecf8c5899ce3850@mail.gmail.com>
 <5d5443650908230051wa8fa77cu280707281fe450ff@mail.gmail.com>
 <5d5443650909070429q1eeb5b78t8398ba670143fbf9@mail.gmail.com>
X-OriginalArrivalTime: 07 Sep 2009 11:44:30.0982 (UTC)
 FILETIME=[8FFAFA60:01CA2FB0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/7/2009 8:29 PM, Trilok Soni wrote:
> Hi Kyungmin,
> 
> On Sun, Aug 23, 2009 at 1:21 PM, Trilok Soni<soni.trilok@gmail.com> wrote:
>> Hi Kyungmin,
>>
>> On Sun, Aug 23, 2009 at 10:15 AM, Kyungmin Park<kmpark@infradead.org> wrote:
>>> Hi,
>>>
>>> There's three types as I know,
>>>
>>> 1) just GPIO enable motor
>>> 2) GPIO & PWM motor.
>>> 3) I2C based GPIO & PWM motor.
>>>
>>> Frankly we made a motor framework at kernel. but I 'm not sure motor
>>> is right naming or not.
>>> I think we need new framework. since it's not input device.
>> I am looking at 3rd type, and evaulating that for embedded systems
>> devices having haptics chips can be programmed under drivers/input or
>> not. It is kind of early discussion and gathering inputs on what could
>> be lacking part in input subsystem for support such category of
>> devices.
>>
>> Is it possible for you to submit your version of code and drivers? It
>> will be good starting point for discussion.
> 
> Any updates on my request ?
> 

Hi, I will post the haptic framework soon(maybe tomorrow) instead of
Kyungmin because he leaves a office for days.

> ---Trilok Soni
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

