Return-Path: <linux-kernel-owner+w=401wt.eu-S1761497AbXK2ICu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761497AbXK2ICu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 03:02:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756438AbXK2ICm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 03:02:42 -0500
Received: from eazy.amigager.de ([213.239.192.238]:50643 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610AbXK2ICk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 03:02:40 -0500
Date: Thu, 29 Nov 2007 09:02:33 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: kernel list <linux-kernel@vger.kernel.org>,
       Alessandro Zummo <alessandro.zummo@towertech.it>
Subject: Re: RTC wakealarm write-only, still has 644 permissions
Message-ID: <20071129080233.GA9434@dose.home.local>
Mail-Followup-To: kernel list <linux-kernel@vger.kernel.org>,
	Alessandro Zummo <alessandro.zummo@towertech.it>
References: <20070920103225.GA4410@elf.ucw.cz> <20070920105002.GA4611@elf.ucw.cz> <200709212238.05130.david-b@pacbell.net> <20071128232647.GC4947@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071128232647.GC4947@elf.ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 00:26:47 +0100, Pavel Machek wrote:

[...]

> > > Also, is there some documentation for wakealarm?
> > 
> > "git show 3925a5ce44330767f7f0de5c58c6a797009f0f75" has some.
> 
> Thanks. Will put it into Doc*/rtc.txt.

It would be nice if you mention the differences to the old
/proc/acpi/alarm, to help users who want to migrate. Something like in
http://lkml.org/lkml/2007/6/19/264.

Regards,
Tino
