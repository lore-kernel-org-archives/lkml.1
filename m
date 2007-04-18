Return-Path: <linux-kernel-owner+w=401wt.eu-S1751143AbXDRIXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751143AbXDRIXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 04:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbXDRIXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 04:23:39 -0400
Received: from smtp2-g19.free.fr ([212.27.42.28]:41477 "EHLO smtp2-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbXDRIXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 04:23:38 -0400
Message-ID: <4625D546.9010205@tremplin-utc.net>
Date: Wed, 18 Apr 2007 10:22:30 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <Eric.Piel@tremplin-utc.net>
User-Agent: Thunderbird 2.0b2 (X11/20070307)
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@insightbb.com>
CC: mitr@volny.cz, otauber@web.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] wistron_btns: add led support
References: <4620FCB0.6060603@tremplin-utc.net> <200704180025.46956.dtor@insightbb.com>
In-Reply-To: <200704180025.46956.dtor@insightbb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

18.04.2007 06:25, Dmitry Torokhov wrote/a écrit:
> On Saturday 14 April 2007 12:09, Éric Piel wrote:
>> This patch adds support for mail and wifi leds. It modifies the Kconfig 
>> file to automatically pull led_class with wistron_btns, hopefully 
>> everyone is fine with this.
>>
> 
> Was there 1/2 file?

Ooops, sorry, this mail was not mean to be sent yet (my thunderbird and 
I misunderstood each other). It works here but I'll try it on another 
laptop to confirm the patch is good.

Hopefully, I'll come back to you tomorrow with no changes and a little 
1/2 patch :-)

Eric
