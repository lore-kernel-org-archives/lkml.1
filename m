Return-Path: <linux-kernel-owner+w=401wt.eu-S1755231AbXLLVQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbXLLVQ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 16:16:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751047AbXLLVQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 16:16:21 -0500
Received: from mail.hauppauge.com ([167.206.143.4]:2445 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbXLLVQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 16:16:21 -0500
Message-ID: <47604F94.6060706@linuxtv.org>
From: mkrufky@linuxtv.org
To: xyzzy@speakeasy.org
Cc: bunk@kernel.org, toralf.foerster@gmx.de, v4l-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       mchehab@infradead.org
Subject: Re: [v4l-dvb-maintainer] [2.6 patch] drivers/media/Makefile: alwa
	ys enter video/
Date: Wed, 12 Dec 2007 16:16:04 -0500
MIME-Version: 1.0
X-Mailer: Internet Mail Service (5.5.2657.72)
in-reply-to: <Pine.LNX.4.58.0712121310330.111@shell2.speakeasy.net>
x-originalarrivaltime: 12 Dec 2007 21:12:47.0398 (UTC) FILETIME=[BEB7EC60:01C83D03]
user-agent: Thunderbird 2.0.0.9 (Windows/20071031)
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trent Piepho wrote:
> On Wed, 12 Dec 2007, Adrian Bunk wrote:
>   
>>> I don't see any issue on making both dependent on VIDEO_TUNER for
>>> 2.6.24, since they are currently used only by tuner core module
>>> (tuner.ko).
>>> ...
>>>       
>> If "selected code isn't included" also counts as a bug at least dabusb
>> is also affected by the same bug.
>>     
>
>   
>> What about the patch below instead that fixes the actual bug instead of
>> working around it?
>>     
>
> Pretty much exactly the same as the patch I posted on Oct 19th.  Some
> people like to make things harder than they need to be.
>
> http://article.gmane.org/gmane.comp.video.video4linux/35274

Interesting.  I've no idea why I never received that email from you, Trent.

Whomever invented email should be shot.  :-P

Please push this in.

-Mike

