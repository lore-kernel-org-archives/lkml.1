Return-Path: <linux-kernel-owner+w=401wt.eu-S1753561AbYIEMdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbYIEMdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 08:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbYIEMdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 08:33:17 -0400
Received: from 1wt.eu ([62.212.114.60]:3196 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154AbYIEMdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 08:33:16 -0400
Date: Fri, 5 Sep 2008 14:33:02 +0200
From: Willy Tarreau <w@1wt.eu>
To: ivaylo@bglans.net
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Marvel IDE 88SE6101 2.4.XX support
Message-ID: <20080905123302.GB22545@1wt.eu>
References: <Pine.LNX.4.62.0708102357470.24424@mail.bglans.net> <Pine.LNX.4.64.0809042115350.11281@mail.bglans.net> <20080904193625.652bf013@lxorguk.ukuu.org.uk> <20080905040326.GB17104@1wt.eu> <Pine.LNX.4.64.0809051317430.9897@mail.bglans.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0809051317430.9897@mail.bglans.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Sep 05, 2008 at 01:37:35PM +0300, ivaylo@bglans.net wrote:
> 
> Hello,
> 
> Thanks, Alan for your comment about Marvell PATA IDE driver.
> In this time I'm a litle bit busy and do not have time to backport driver 
> in 2.4 probably after a time I'll try (I'm not a profesional C programer 
> and it is litle hard to me). I correct generic IDE patch and send you in 
> the attached file.

OK. BTW, next time, please post it in pure text form, so that people on
the list can easily review and comment it.

> I make also patch to update e1000 driver in the 2.4 kernel to e1000-7.6.5 
> and add support for:
> 00:19.0 Ethernet controller: Intel Corporation 82801I (ICH9 Family) 
> Gigabit Ethernet Controller (rev 02)
> 
> But I'm not sure if there are any license violations and any other person 
> who manage network drivers to send it to him. If you know something about 
> it please tell me to send the patch for testing and e.t.c.

Please contact Auke Kok and/or Jesse Brandeburg at intel. They are the
driver's maintainers, and since they still support it, I do not want to
change it without their agreement. If they want to propose an upgrade,
I'll trust them.

Regards,
Willy

