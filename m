Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967936Ab0B0IDc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 03:03:32 -0500
Received: from perec.tyrell.hu ([66.197.149.104]:50422 "EHLO perec.tyrell.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967911Ab0B0IDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 03:03:31 -0500
Message-ID: <4B88D1CF.3040805@maroy.hu>
Date: Sat, 27 Feb 2010 09:03:27 +0100
From: =?ISO-8859-1?Q?=C1kos_Mar=F3y?= <akos@maroy.hu>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Edward Shao <laface.tw@gmail.com>
CC: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, USB list <linux-usb@vger.kernel.org>
Subject: Re: pm_op(): usb_dev_suspend+0x0/0x10 returns -2 on USB device 	8087:0020
References: <Pine.LNX.4.44L0.1002241137030.2436-100000@iolanthe.rowland.org>	 <4B85A9D3.6060709@maroy.hu> <ff05f3d01002252121k2a757caexae13a8d919b2a170@mail.gmail.com>
In-Reply-To: <ff05f3d01002252121k2a757caexae13a8d919b2a170@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Edward,

> the whole system freezes for about 5 seconds or more?
> I meet a very similar issue before on HP Envy 15 laptop when I plugged
> usb device on xhci port.
> My problem was BIOS still controlled xhci host controller.
> Maybe you can try this patch.
> http://markmail.org/message/vqcbzks4gnbrlir3

thanks, indeed, this seems to have solved the freezing issue!


Akos

