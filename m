Return-Path: <linux-kernel-owner+w=401wt.eu-S1751630AbXEFVzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630AbXEFVzO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 17:55:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbXEFVzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 17:55:13 -0400
Received: from mail.z-net.ru ([89.113.80.10]:3296 "EHLO mail.z-net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbXEFVzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 17:55:12 -0400
Date: Mon, 7 May 2007 01:50:55 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Paul Sokolovsky <pmiscml@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Greg KH <gregkh@suse.de>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Shem Multinymous <multinymous@gmail.com>, kernel-discuss@handhelds.org
Subject: Re: [Kernel-discuss] Re: [PATCH 3/8] Universal power supply class
	(was: battery class)
Message-ID: <20070506215055.GA10538@zarina>
Reply-To: cbou@mail.ru
References: <20070503213139.GC20067@zarina> <41840b750705032155w21d98b5g6236daf9bff66606@mail.gmail.com> <20070505035413.GB21359@khazad-dum.debian.net> <20070505123230.GA6460@zarina> <67630751.20070505172956@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <67630751.20070505172956@gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Sat, May 05, 2007 at 05:29:56PM +0300, Paul Sokolovsky wrote:
> Hello Anton,
> 
>         But in real world, it's rather common to colloquially name
> such kind of power "AC", and that's "term" is known to many-many
> people, and intuitively understood even for those, who didn't hit it yet.
> Actually, this discussion is good confirmation that's the case -
> people understand in what meaning it is used here, and go to point
> that it's not "scientifically" correct.

I fully agree here. Yes, AC is common term, but might be really
confusing for people who really know what AC is. ;-)

In past review we tried to drop any point of confusions (we agreed to
separate capacity, charge and energy terms), and now we've found
another point: AC, DC, MAINS. So, let's again eliminate any possibility
of confusion, and name things with correct terms.


Thanks,

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2
