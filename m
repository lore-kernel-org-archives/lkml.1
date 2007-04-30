Return-Path: <linux-kernel-owner+w=401wt.eu-S1423341AbXD3POm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423341AbXD3POm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755465AbXD3POf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:14:35 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:36694 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755445AbXD3POX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:14:23 -0400
Date: Mon, 30 Apr 2007 17:14:06 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Johannes Berg <johannes@sipsolutions.net>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 28/36] Use menuconfig objects II - sound
In-Reply-To: <Pine.LNX.4.61.0704301708120.29151@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704301713170.29151@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr> 
 <Pine.LNX.4.61.0704301350460.29151@yvahk01.tjqt.qr> <1177942754.5102.76.camel@johannes.berg>
 <Pine.LNX.4.61.0704301708120.29151@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 30 2007 17:12, Jan Engelhardt wrote:
>On Apr 30 2007 16:19, Johannes Berg wrote:
>>
>>For the aoa bits this ends up having two "Apple Onboard Audio driver"
>>bits which is a bit confusing.
>
>Hold it hold it. You confuse the hell out of me. :p
>There is exactly one SND_AOA in my patch, where do you see the second
>menu entry in menuconfig?
>(Also note that I don't see a way to make CONFIG_PPC_PMAC turn up anyhow in
>`make menuconfig ARCH=ppc`!)

Argh... my local copy of the patch got twisted. I perhaps should redo it 
from a base kernel - and sorry for the extra mail noise.


Jan
-- 
