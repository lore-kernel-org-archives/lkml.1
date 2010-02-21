Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab0BUDKt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 22:10:49 -0500
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:54302 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045Ab0BUDKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 22:10:48 -0500
Message-ID: <4B80A434.2000708@shikadi.net>
Date: Sun, 21 Feb 2010 13:10:44 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.8.1.23) Gecko/20091130 Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
CC: LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: UML error - apps killed 50% of the time
References: <4B78EF9C.6040801@shikadi.net>	 <20100215090053.GG12076@hack.private> <4B79122A.9070102@shikadi.net>	 <20100215122732.GM12076@hack.private> <4B79BC66.9090408@shikadi.net>	 <20100220144529.GE3000@hack> <4B80963D.4030707@shikadi.net> <2375c9f91002201815tafcf286ga28337ee37c9dc02@mail.gmail.com>
In-Reply-To: <2375c9f91002201815tafcf286ga28337ee37c9dc02@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> That patch won't apply - if I am reading it correctly it looks like it was
>> already part of the original patch
>> (http://patchwork.kernel.org/patch/79358/)
>
> No, they are different. Sorry that the above page mangles the patch,
> please try this one:
>
> http://lkml.org/lkml/diff/2010/2/15/61/1

Oh my mistake, I thought it was to be applied on top of the original patch.  I 
reverted the original patch and applied this one, and it seems to have fixed 
the problem!

I can now fully boot into the UML and run programs again - thanks for your help!

Cheers,
Adam.
