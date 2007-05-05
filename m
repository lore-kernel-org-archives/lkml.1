Return-Path: <linux-kernel-owner+w=401wt.eu-S934171AbXEESAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934171AbXEESAd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 14:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934176AbXEESAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 14:00:33 -0400
Received: from outmail1.freedom2surf.net ([194.106.33.237]:36894 "EHLO
	outmail1.freedom2surf.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934171AbXEESAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 14:00:32 -0400
Subject: Re: [Kernel-discuss] Re: [PATCH 3/8] Universal power supply class
	(was: battery class)
From: ian <spyro@f2s.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Shem Multinymous <multinymous@gmail.com>, Anton Vorontsov <cbou@mail.ru>,
       Greg KH <gregkh@suse.de>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org
In-Reply-To: <20070505035413.GB21359@khazad-dum.debian.net>
References: <20070503213139.GC20067@zarina>
	 <41840b750705032155w21d98b5g6236daf9bff66606@mail.gmail.com>
	 <20070505035413.GB21359@khazad-dum.debian.net>
Content-Type: text/plain
Date: Sat, 05 May 2007 14:46:26 +0100
Message-Id: <1178372786.3901.4.camel@wirenth>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-05 at 00:54 -0300, Henrique de Moraes Holschuh wrote:

> Given that USB-power *is* usually also "dumb" (i.e. it doesn't do any
> control signaling over the USB bus for power-control purposes),

it might be dumb, but it is useful to know wether the PDA is charging
from usb or mains power. and some devices allow one to switch on / off
the ability to charge via usb

