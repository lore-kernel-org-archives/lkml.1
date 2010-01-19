Return-Path: <linux-kernel-owner+w=401wt.eu-S1755638Ab0ASVCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab0ASVCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 16:02:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755573Ab0ASVCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 16:02:22 -0500
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:32265 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754759Ab0ASVCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 16:02:22 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAA+tVUtbssBB/2dsb2JhbADZXQqEKQQ
Date: Tue, 19 Jan 2010 22:02:20 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Joe Perches <joe@perches.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] watchdogs: constify struct watchdog_info
Message-ID: <20100119210220.GD3804@infomag.iguana.be>
References: <1263865537.18117.23.camel@Joe-Laptop.home> <20100119085613.GA3804@infomag.iguana.be> <1263932897.18117.40.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263932897.18117.40.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

> > I created another patch that does this and moves the struct
> > out of the ioctl call as part of the generic watchdog conversion.
> 
> Great.

I'll post the first 2 patches for review in a couple of minutes.

> I did send you awhile ago a patch series
> to convert to pr_fmt() and pr_<level>.
> 
> http://lkml.org/lkml/2009/7/21/5
> 
> Do you still eventually want those?

I didn't forget them and want them definitely in the future.
But first I would like to put my efforts in completing the generic watchdog setup (before Alan Cox turns grey and more then 100 years old :-) ). (Alan: sorry that it takes a long time, but since I'm living as a telecom consultant nowadays and having to support a wife and 2 children, my development activities are on a lower level now).

Kind regards,
Wim.

