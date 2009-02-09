Return-Path: <linux-kernel-owner+w=401wt.eu-S1755405AbZBIXh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbZBIXh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 18:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbZBIXhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 18:37:16 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:26137 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbZBIXhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 18:37:15 -0500
X-Spam-Flag: NO
X-Spam-Score: -12.589
Message-ID: <4990BE23.8080301@tremplin-utc.net>
Date: Tue, 10 Feb 2009 00:37:07 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.19) Gecko/20081231 Mandriva/2.0.0.19-1mdv2009.1 (2009.1) Thunderbird/2.0.0.19 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Palatis Tseng <palatis@gmail.com>
Cc: giuseppe.bilotta@gmail.com, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH] lis3lv02d: add axes knowledge of HP Pavilion dv5 models
References: <1233967681-6378-1-git-send-email-giuseppe.bilotta@gmail.com> <498D9F02.9000107@tremplin-utc.net> <498E46F2.1020401@gmail.com>
In-Reply-To: <498E46F2.1020401@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Palatis Tseng schreef:
> Éric Piel 提到:
>>> With the laptop standing still on my desk jstest reports X and Y values
>>> fluctuating from -8k to +8k (more or less). I assume this is normal?
>> What does "k" stands for? If that's the unit of the joystick output:
>> yes, that's perfectly normal, just some noise/vibration. If that's 1000,
>> it's far too much to be normal.
>>
>> Eric
> "k" is for kilo, which means 1000.
> I verified this and found out that i've made a mistake. following the
> steps in
:
No problem, the patch from Giuseppe will get the axex fine :-)

However, could you let use know if you too, on your laptop, have huge
fluctuations even when the laptop is not moving? Could you give an idea
of the minimum and maximum values of each axis when the laptop is set
normally on the desk without touching it?

Thanks,
Eric
