Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbYGFFLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbYGFFLm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 01:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbYGFFLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 01:11:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46657 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbYGFFLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 01:11:33 -0400
Subject: Re: [linux-dvb] [PATCH] Remove fdump tool for av7110 firmware
From: Jaswinder Singh <jaswinder@infradead.org>
To: Oliver Endriss <o.endriss@gmx.de>
Cc: linux-dvb@linuxtv.org, LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Woodhouse <dwmw2@infradead.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <200807060315.51736@orion.escape-edv.de>
References: <1214139259.2994.8.camel@jaswinder.satnam>
	 <200807060315.51736@orion.escape-edv.de>
Content-Type: text/plain; charset=utf8
Date: Sun, 06 Jul 2008 10:34:25 +0530
Message-Id: <1215320665.2768.15.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Oliver,

On Sun, 2008-07-06 at 03:15 +0200, Oliver Endriss wrote:
> Jaswinder Singh wrote:
> > There's no point in this, since the user can use the BUILTIN_FIRMWARE
> > option to include arbitrary firmware files directly in the kernel image.
> 
> NAK! 

﻿I think you are watching two weeks old patch.

Please check updated patch from :-

http://git.infradead.org/users/dwmw2/firmware-2.6.git?a=commitdiff;h=cf852ae7e54eaf8944e1e734321fa6d5285379f1

And give us your valuable comments.

> This option allows to compile the firmware into the _driver_,

We also compile firmware without fdump.

> which is very useful if you want to test various driver/firmware
> combinations. ﻿Having the firmware in the _kernel_ does not help!
> 

For testing purpose kernel/drivers source tree is not suitable.
Please find some other suitable place.

> Well, I am tired to fight for this option in the kernel every other
> month. :-(
> 

yeah I understand, fighting with Truth is not easy ;)

Thank you,

Jaswinder Singh.

