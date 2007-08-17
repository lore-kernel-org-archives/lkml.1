Return-Path: <linux-kernel-owner+w=401wt.eu-S1761292AbXHQTwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761292AbXHQTwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 15:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754240AbXHQTwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 15:52:11 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:41866 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816AbXHQTwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 15:52:10 -0400
Date: Fri, 17 Aug 2007 21:52:09 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: David Brownell <david-b@pacbell.net>
cc: Kay Sievers <kay.sievers@vrfy.org>, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       a.zummo@towertech.it, linux-kernel@vger.kernel.org,
       rtc-linux@googlegroups.com, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] rtc: Make rtc-ds1742 driver hotplug-aware
In-Reply-To: <200708171250.09653.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.64.0708172151050.5186@fbirervta.pbzchgretzou.qr>
References: <200708170823.15894.david-b@pacbell.net> <200708170955.06388.david-b@pacbell.net>
 <1187371126.4253.10.camel@lov.localdomain> <200708171250.09653.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 17 2007 12:50, David Brownell wrote:
>On Friday 17 August 2007, Kay Sievers wrote:
>> On Fri, 2007-08-17 at 09:55 -0700, David Brownell wrote:
>> > On Friday 17 August 2007, Kay Sievers wrote:
>> > > Again,
>> > 
>> > "Again"?
>> 
>> We exchanges several mails a few weeks ago after the Debian bug caused
>> by a modprobe loop. 
>
>Which has been fixed for some time now; it was caused by legacy
>drivers, which are incapable of hotplugging.

Speaking of which ... does not platform: thing affect pcspkr and psmouse for
x86 too?


	Jan
-- 
