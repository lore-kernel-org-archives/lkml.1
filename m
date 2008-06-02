Return-Path: <linux-kernel-owner+w=401wt.eu-S1754213AbYFBAqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbYFBAqL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 20:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756354AbYFBApy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 20:45:54 -0400
Received: from smtp-04.mandic.com.br ([200.225.81.151]:59357 "EHLO
	smtp-04.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756294AbYFBApx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 20:45:53 -0400
Message-ID: <484342B6.7020605@diamondcut.com.br>
Date: Sun, 01 Jun 2008 21:45:42 -0300
From: "Renato S. Yamane" <yamane@diamondcut.com.br>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: devzero@web.de
CC: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>, hmh@hmh.eng.br
Subject: Re: [Bug 10797] Something is consuming power after shutdown
References: <300254332@web.de>
In-Reply-To: <300254332@web.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devzero@web.de wrote:
> Renato S. Yamane wrote:
>> Pavel Machek wrote:
>>> Renato S. Yamane wrote:
>>> ...
>>>> <http://bugzilla.kernel.org/show_bug.cgi?id=10797>
>>>> <http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=481493>
>>>
>>> Try to find out which component eats power, eg. by opening the machine
>>> searching for heat.
>>>
>>> (And yes, your hw is broken; on pc it is traditionaly hw
>>> responsibility to power machine down.)
>>
>> OK, I try do this but I think this is very difficult because demand
>> power is very low and is not enought to do hot some component. But I
>> will try.
> 
> i also don`t think that you can find something which is noticeably warm
> this way - 4% of your battery in 12hrs - that "hot spot" should be hard
> to identify

Yes, you are right!
I try find a "hot spot" and it's impossible.

> if your notebook powers down and doesn`t show that something is still
> "on" and consuming power - i`d call that "broken by design".

I don't know why, but as commented in Bug #10797, if I close my LCD
Display (activing LID), power on again (because when LID is actived, my
laptop hibernate), and shutdown, my battery charge not is changed.

Best regards,
Renato S. Yamane
