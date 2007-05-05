Return-Path: <linux-kernel-owner+w=401wt.eu-S1423083AbXEEPm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423083AbXEEPm6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 11:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423214AbXEEPm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 11:42:57 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:58228 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423083AbXEEPm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 11:42:56 -0400
Date: Sat, 5 May 2007 17:06:03 +0300
From: Paul Sokolovsky <pmiscml@gmail.com>
X-Priority: 3 (Normal)
Message-ID: <1609424106.20070505170603@gmail.com>
To: ian <spyro@f2s.com>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, kernel-discuss@handhelds.org,
       Greg KH <gregkh@suse.de>, <linux-kernel@vger.kernel.org>,
       Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
       Shem Multinymous <multinymous@gmail.com>
Subject: Re: [Kernel-discuss] Re: [PATCH 3/8] Universal power supply class (was: battery class)
In-Reply-To: <1178372786.3901.4.camel@wirenth>
References: <20070503213139.GC20067@zarina> <41840b750705032155w21d98b5g6236daf9bff66606@mail.gmail.com> <20070505035413.GB21359@khazad-dum.debian.net> <1178372786.3901.4.camel@wirenth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello ian,

Saturday, May 5, 2007, 4:46:26 PM, you wrote:

> On Sat, 2007-05-05 at 00:54 -0300, Henrique de Moraes Holschuh wrote:

>> Given that USB-power *is* usually also "dumb" (i.e. it doesn't do any
>> control signaling over the USB bus for power-control purposes),

> it might be dumb, but it is useful to know wether the PDA is charging
> from usb or mains power. and some devices allow one to switch on / off
> the ability to charge via usb

        And USB does have power budgetting requirements, etc. (like
was already pointed in own of initial review messages). So, USB
is definitely not the same thing as "dumb DC".


-- 
Best regards,
 Paul                            mailto:pmiscml@gmail.com

