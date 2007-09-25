Return-Path: <linux-kernel-owner+w=401wt.eu-S1760087AbXIYVA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760087AbXIYVA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 17:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbXIYVAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 17:00:20 -0400
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:45291
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751913AbXIYVAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 17:00:19 -0400
In-Reply-To: <d120d5000709251341s222c8560wdf46c5a3c9b36ada@mail.gmail.com>
References: <6D36DFB9-B26D-4CEA-B7AD-0216F7124FC5@it-loops.com> <d120d5000709251051n45e415e6gbdd87a98f0b8cdd4@mail.gmail.com> <B5B5C841-6068-413B-A765-73A34E988FAA@it-loops.com> <d120d5000709251341s222c8560wdf46c5a3c9b36ada@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <48F42D3E-BD7C-4F59-8384-3429D0F4CF4D@it-loops.com>
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Michael Guntsche <mike@it-loops.com>
Subject: Re: 2.6.23 /proc/bus/input/devices content question
Date: Tue, 25 Sep 2007 23:00:02 +0200
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 25, 2007, at 22:41, Dmitry Torokhov wrote:

>
> Ok, this is expected. Input devices were converted form class devices
> into standard devices. Unless SYSFS_DEPRECTAED is set to Y sysfs
> changes are expected.
>

Ah ok, so this is a known change. I thought about enabling it for  
testing but did not do it because I did not do it with 2.6.22 either.
Thanks for the clarification Dmitry.

Kind regards,
Michael
