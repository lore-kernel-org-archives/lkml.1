Return-Path: <linux-kernel-owner+w=401wt.eu-S1751821AbXA0OxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbXA0OxV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 09:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbXA0OxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 09:53:20 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:57288 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbXA0OxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 09:53:20 -0500
Date: Sat, 27 Jan 2007 15:53:03 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Florian Schmidt <mista.tapas@gmx.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: blacklist kernel boot option
In-Reply-To: <200701270222.36060.mista.tapas@gmx.net>
Message-ID: <Pine.LNX.4.61.0701271552090.22295@yvahk01.tjqt.qr>
References: <200701270222.36060.mista.tapas@gmx.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 27 2007 02:22, Florian Schmidt wrote:
>
>i was wondering whether there exists any mechanism to blacklist modules
>from being loaded besides the typical etc/modprobe.d/blacklist type
>mechanisms. Sometimes you have a module oopsing because of faulty hw
>which cannot be removed rendering the system unbootable. And sometimes
>there's just no way to edit the modprobe blacklist because you cannot
>boot the box :) Basically i would like to setup a list of module names
>the kernel simply refuses to load..
>
>blacklist=some_module,some_other_module,some_third_module

>Does something exist?

I think there was something like that although I can't remember
either what it was.

	-`J'
-- 
