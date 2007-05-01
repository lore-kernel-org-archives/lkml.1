Return-Path: <linux-kernel-owner+w=401wt.eu-S1161149AbXEAUjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161149AbXEAUjJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945925AbXEAUix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:38:53 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:51562 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945920AbXEAUiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:38:50 -0400
Date: Tue, 1 May 2007 22:37:53 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 18/36] Use menuconfig objects II - MMC
In-Reply-To: <4637636C.50704@drzeus.cx>
Message-ID: <Pine.LNX.4.61.0705012237140.18504@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0704301340180.29151@yvahk01.tjqt.qr> <4637636C.50704@drzeus.cx>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 1 2007 17:57, Pierre Ossman wrote:
>Jan Engelhardt wrote:
>> Change Kconfig objects from "menu, config" into "menuconfig" so
>> that the user can disable the whole feature without having to
>> enter the menu first.
>> 
>> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
>
>As promised, an updated patch.

If it works, no problem. just put your sign-off somewhere
and let Andrew (or the appropriate subsys maintainer) have it :)



Jan
-- 
