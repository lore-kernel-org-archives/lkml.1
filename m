Return-Path: <linux-kernel-owner+w=401wt.eu-S1161621AbXEDSu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161621AbXEDSu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 14:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161622AbXEDSu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 14:50:26 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:51699 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161621AbXEDSuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 14:50:23 -0400
Date: Fri, 4 May 2007 20:48:27 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: =?UTF-8?B?UmFmYcWCIEJpbHNraQ==?= <rafalbilski@interia.pl>
cc: Dave Jones <davej@codemonkey.org.uk>, cpufreq@lists.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: cpufreq longhaul locks up
In-Reply-To: <463B687D.1020600@interia.pl>
Message-ID: <Pine.LNX.4.61.0705042042270.18504@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0705041200370.18504@yvahk01.tjqt.qr>
 <463B687D.1020600@interia.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 4 2007 19:08, Rafał Bilski wrote:
>
>Btw. I've been writting many times: if You want to use ondemand with 
>Longhaul You don't need cpufreq at all.

Does VIA Nehemiah do hardware-driven autoregulation like Transmeta
Crusoe too? (I suspect no, have not seen that happen.)

>It is just one another cool gadget for You.
>Longhaul wasn't designed to change frequency often. 

Is there a way I can start with a specific governor (powersave) right
from the start so that all devices that Linux will initialize assume
the CPU runs at <choose something> MHz?

>It has big latency and requires so much preparation that it isn't worth 
>if You don't need to save power or cool down CPU. 

I found frequency switching on my VIA to be fast enough.


Jan
-- 
