Return-Path: <linux-kernel-owner+w=401wt.eu-S1946035AbXD3QSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946035AbXD3QSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423622AbXD3QQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 12:16:38 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:33329 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946309AbXD3QPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 12:15:55 -0400
Date: Mon, 30 Apr 2007 18:13:17 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Johannes Berg <johannes@sipsolutions.net>
cc: Jaroslav Kysela <perex@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Liam Girdwood <liam.girdwood@wolfsonmicro.com>
Subject: Re: [PATCH 28/36 #2] Use menuconfig objects II - sound
In-Reply-To: <1177947671.5102.103.camel@johannes.berg>
Message-ID: <Pine.LNX.4.61.0704301812020.29151@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr> 
 <Pine.LNX.4.61.0704301350460.29151@yvahk01.tjqt.qr> 
 <Pine.LNX.4.61.0704301717300.29151@yvahk01.tjqt.qr> <1177947671.5102.103.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 30 2007 17:41, Johannes Berg wrote:
>On Mon, 2007-04-30 at 17:21 +0200, Jan Engelhardt wrote:
>
>> Here's the updated thing wrt. AOA.
>
>Looks good, thanks. There is the quirk that now you need the core module
>if you want just i2sbus, but that's ok since i2sbus without the rest of
>aoa is currently useless (it might become useful if we ever write a
>modem driver, but that's probably not going to happen.)

Ah that also answers my question from the bottom of
http://lkml.org/lkml/2007/4/30/234


Jan
-- 
