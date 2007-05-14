Return-Path: <linux-kernel-owner+w=401wt.eu-S1759133AbXENRvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759133AbXENRvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 13:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756384AbXENRvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 13:51:08 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:48214 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756132AbXENRvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 13:51:07 -0400
Date: Mon, 14 May 2007 19:48:38 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: mgarski@post.pl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Convert files to UTF-8 and some cleanups
In-Reply-To: <46486EAE.3060009@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.61.0705141947390.9570@yvahk01.tjqt.qr>
References: <4647A52A.8000709@post.pl> <4647A868.4070201@post.pl>
 <46486EAE.3060009@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On May 14 2007 16:14, Stefan Richter wrote:
>Marcin Garski wrote:
>> Content-Type: application/octet-stream;
>>  name="linux-2.6.22-rc1-utf-8-strings.patch.bz2"
>> Content-Transfer-Encoding: base64
>> Content-Disposition: attachment;
>>  filename="linux-2.6.22-rc1-utf-8-strings.patch.bz2"
>> 
>> QlpoOTFBWSZTWSc/F00Ahxp/v///itd///////////////8QQO6yN0QYAABArrIlRGBofng9
>> APLeS9999e3t9HBeePnl0PJwG73R777qguxoH3sAPfYaKB0BwABdbe4C9nRevqU6lwXTg8De

I've had a quick look at it...

  * Copyright (C) 2004 Nokia Corporation
  * Written by Tony Lindgren <tony@atomide.com>
- * Major cleanups by Juha YrjXlX <juha.yrjola@nokia.com>
+ * Major cleanups by Juha Yrjölä <juha.yrjola@nokia.com>


I thought I already fixed that part with the patch from
http://lkml.org/lkml/2007/1/8/222

but of course I can't tell without getting at that .bz2 thing I
sent back them. Anyone know of a site that stores these too?



	Jan
-- 
