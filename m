Return-Path: <linux-kernel-owner+w=401wt.eu-S1753194AbZIGMdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbZIGMdg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 08:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750740AbZIGMdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 08:33:35 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:43599 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbZIGMdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 08:33:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=dmAEkCwR1+YOhZFsYcM+Y9lv3Il7+GFA5jZ1q+TsGW6z7qkPDd7KaWoCgidZGTFCDk
         bM0tbkCwqlLkqecUjs5ZJVoFZusnByj38eMxSJH4Nd0BO/TRV+eU8ETiSOBHGMlYmBSC
         W6F9rGHd8HWZFpB1O/M+ORLzYIPysTKu1FVaA=
MIME-Version: 1.0
In-Reply-To: <4AA4F21E.5080400@samsung.com>
References: <5d5443650908221004y5b893382m368dc18a38636c1b@mail.gmail.com>
	 <4A902904.2090008@gmail.com>
	 <9c9fda240908222145j1938baa3v3ecf8c5899ce3850@mail.gmail.com>
	 <5d5443650908230051wa8fa77cu280707281fe450ff@mail.gmail.com>
	 <5d5443650909070429q1eeb5b78t8398ba670143fbf9@mail.gmail.com>
	 <4AA4F21E.5080400@samsung.com>
Date: Mon, 7 Sep 2009 17:56:55 +0530
Message-ID: <5d5443650909070526w463838d5u69fff7a5c7d435a6@mail.gmail.com>
Subject: Re: haptics devices linux driver support
From: Trilok Soni <soni.trilok@gmail.com>
To: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: Kyungmin Park <kmpark@infradead.org>, Jiri Slaby <jirislaby@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joonyoung Shim,

On Mon, Sep 7, 2009 at 5:14 PM, Joonyoung Shim<jy0922.shim@samsung.com> wrote:
> On 9/7/2009 8:29 PM, Trilok Soni wrote:
>> Hi Kyungmin,
>>
>> On Sun, Aug 23, 2009 at 1:21 PM, Trilok Soni<soni.trilok@gmail.com> wrote:
>>> Hi Kyungmin,
>>>
>>> On Sun, Aug 23, 2009 at 10:15 AM, Kyungmin Park<kmpark@infradead.org> wrote:
>>>> Hi,
>>>>
>>>> There's three types as I know,
>>>>
>>>> 1) just GPIO enable motor
>>>> 2) GPIO & PWM motor.
>>>> 3) I2C based GPIO & PWM motor.
>>>>
>>>> Frankly we made a motor framework at kernel. but I 'm not sure motor
>>>> is right naming or not.
>>>> I think we need new framework. since it's not input device.
>>> I am looking at 3rd type, and evaulating that for embedded systems
>>> devices having haptics chips can be programmed under drivers/input or
>>> not. It is kind of early discussion and gathering inputs on what could
>>> be lacking part in input subsystem for support such category of
>>> devices.
>>>
>>> Is it possible for you to submit your version of code and drivers? It
>>> will be good starting point for discussion.
>>
>> Any updates on my request ?
>>
>
> Hi, I will post the haptic framework soon(maybe tomorrow) instead of
> Kyungmin because he leaves a office for days.

Excellent. I just came back from vacation :)


-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
