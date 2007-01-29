Return-Path: <linux-kernel-owner+w=401wt.eu-S1752065AbXA2Usb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbXA2Usb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 15:48:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbXA2Usb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 15:48:31 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:44422 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbXA2Usb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 15:48:31 -0500
Date: Mon, 29 Jan 2007 21:48:14 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Kevin Nicoll <blort128@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Multiple ip= boot arguments?
In-Reply-To: <e4fa6c610701291036r7ff384e4u78d3995ab3d042d8@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0701292146470.5077@yvahk01.tjqt.qr>
References: <e4fa6c610701291036r7ff384e4u78d3995ab3d042d8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 29 2007 12:36, Kevin Nicoll wrote:
>
> My question is if it is intended to be able to use more than one "ip="
> parameter in the kernel command line,

Possibly not ...

> or if I'm supposed to use a startup script instead.

This is the preffered way nowadays. One day, hopefully,
CONFIG_IP_PNP can go away.


	-`J'
-- 
