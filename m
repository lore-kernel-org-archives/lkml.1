Return-Path: <linux-kernel-owner+w=401wt.eu-S1759752AbXENULd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759752AbXENULd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757451AbXENULQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:11:16 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:41583 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756953AbXENULO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:11:14 -0400
Date: Mon, 14 May 2007 22:10:20 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: mgarski@post.pl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Convert files to UTF-8 and some cleanups
In-Reply-To: <tkrat.0d89f95b66d8bb2c@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.61.0705142209090.9570@yvahk01.tjqt.qr>
References: <4647A52A.8000709@post.pl> <4647A868.4070201@post.pl>
 <46486EAE.3060009@s5r6.in-berlin.de> <Pine.LNX.4.61.0705141947390.9570@yvahk01.tjqt.qr>
 <tkrat.0d89f95b66d8bb2c@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Report: Content analysis: 1.3 points, 6.0 required
	1.3 INFO_TLD               URI: Contains an URL in the INFO top-level domain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 14 2007 20:06, Stefan Richter wrote:
>On 14 May, Jan Engelhardt wrote:
>> I've had a quick look at it...
>> 
>>   * Copyright (C) 2004 Nokia Corporation
>>   * Written by Tony Lindgren <tony@atomide.com>
>> - * Major cleanups by Juha YrjXlX <juha.yrjola@nokia.com>
>> + * Major cleanups by Juha Yrjölä <juha.yrjola@nokia.com>
>> 
>> 
>> I thought I already fixed that part with the patch from
>> http://lkml.org/lkml/2007/1/8/222
>> 
>> but of course I can't tell without getting at that .bz2 thing I
>> sent back them. Anyone know of a site that stores these too?
>
>http://marc.info/?l=linux-kernel&m=116828781409931

I checked.
Now that kinda sucks, everyone does the same job over and over,
I did a ton of utf8 fixes and they did not get applied. (Granted,
I did not cc Andrew, Linus or trivial).

>-- 
>Stefan Richter
>-=====-=-=== -=-= -===-
>http://arcgraph.de/sr/
>
>

	Jan
-- 
