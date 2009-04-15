Return-Path: <linux-kernel-owner+w=401wt.eu-S1759636AbZDOMbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636AbZDOMbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 08:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758334AbZDOMbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 08:31:40 -0400
Received: from fmmailgate05.web.de ([217.72.192.243]:47270 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbZDOMbk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 08:31:40 -0400
Date: Wed, 15 Apr 2009 14:31:36 +0200
Message-Id: <671763813@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Cc: dragoslav.zaric.kd@gmail.com
Subject: Re: Fast testing
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1/WG01zAjD5d8krFhwWg2sISxPsmIEJvDK/6owPURo2cMI9m
 boW1JPwGtUhCdtRcciBIQ8mL2Qw9EnQCCiEf3hQEHiCEaY0fUg=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if your kernel changes are not driver/hardware specific and you want to test/develop more
generic features, then you should have a look at UserModeLinux. great for testing & debugging.
you don´t need any bootloader to run UserModeLinux, you can start it from commandline 
just like any other process. Basically, it`s a Linux kernel ported to Linux API (instead of different ARCH)

regards
roland


List:       linux-kernel
Subject:    Re: Fast testing
From:       Dragoslav Zaric <dragoslav.zaric.kd () gmail ! com>
Date:       2009-04-14 16:44:43
Message-ID: 2d05c4580904140944s1dec7dfewf42862ac698bf669 () mail ! gmail ! com
[Download message RAW]

Well Arjan it looks that you have a nice laptop if that is your
reboot time :)

The idea about this is that when you have some idea and you
write code, doing reboot and stuff can make you forgot your idea.
If you write normal program you probably press "build" or type
"gcc" at least 10 times to see what is going on. I think that only
thing necessary is: system to boot one time and then you can
load image in ram memory as many times as you want. So I am
not sure if this is ok, but at least I will try.

But I am not saying that if this works, the changes are going to
crush or freeze system more often than produce any kind of result :)

For example, we can boot from GRUB command line, so this would
be something like falling back to GRUB command line [to that point]
and load [any] image in ram memory.

thanks,

Dragoslav Zaric

__________________________________________________________________________
Verschicken Sie SMS direkt vom Postfach aus - in alle deutschen und viele 
ausländische Netze zum gleichen Preis! 
https://produkte.web.de/webde_sms/sms



