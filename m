Return-Path: <linux-kernel-owner+w=401wt.eu-S1759414AbXI0VKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759414AbXI0VKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 17:10:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756484AbXI0VKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 17:10:00 -0400
Received: from www.osadl.org ([213.239.205.134]:32992 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755789AbXI0VJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 17:09:59 -0400
Subject: Re: NO_HZ hangs up AMD MK-36
From: Thomas Gleixner <tglx@linutronix.de>
To: Dmitry Tyschenko <dtyschenko@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
In-Reply-To: <a6a840cd0709271401r56d5bebes8e361994ecc5746a@mail.gmail.com>
References: <a6a840cd0709271328p76ee6a22tf3b60678d6a2d455@mail.gmail.com>
	 <200709272259.26412.rjw@sisk.pl>
	 <a6a840cd0709271401r56d5bebes8e361994ecc5746a@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 27 Sep 2007 23:09:57 +0200
Message-Id: <1190927397.23376.147.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-28 at 00:01 +0300, Dmitry Tyschenko wrote:
> Sorry, I am newbie in linux. Hope you was talking about:
> /boot/vmlinuz-2.6.22-1-k7 root=/dev/sda5 ro nohz=off

Yes.

> But it doesn't help for Debians 2.6.22-1 (I don't have another
> prebuiled) still same problems.

Can you please add: nolapic_timer instead ?

Thanks,

	tglx


