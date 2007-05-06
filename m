Return-Path: <linux-kernel-owner+w=401wt.eu-S1755811AbXEFVRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811AbXEFVRZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 17:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755978AbXEFVRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 17:17:25 -0400
Received: from mail.z-net.ru ([89.113.80.10]:3447 "EHLO mail.z-net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755811AbXEFVRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 17:17:24 -0400
Date: Mon, 7 May 2007 01:13:07 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: pHilipp Zabel <philipp.zabel@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Greg KH <gregkh@suse.de>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Shem Multinymous <multinymous@gmail.com>, kernel-discuss@handhelds.org
Subject: Re: [Kernel-discuss] Re: [PATCH 3/8] Universal power supply class
	(was: battery class)
Message-ID: <20070506211307.GC10236@zarina>
Reply-To: cbou@mail.ru
References: <20070503213139.GC20067@zarina> <41840b750705032155w21d98b5g6236daf9bff66606@mail.gmail.com> <20070505035413.GB21359@khazad-dum.debian.net> <20070505123230.GA6460@zarina> <74d0deb30705050639s4166a2acm5fd0947c5c1a8cb8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <74d0deb30705050639s4166a2acm5fd0947c5c1a8cb8@mail.gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2007 at 03:39:40PM +0200, pHilipp Zabel wrote:
> > > secondary notion too, as that is common.  It would be generic.
> > >
> > > Or maybe I just didn't get the idea behind the "type" attribute :-)
> > >
> > > I'd appreciate if these were documented in the text file.
> >
> > I think I got the start point of confusion. It's indeed bad to call such
> > power supply type as AC. Maybe I should it rename to ADAPTER? Or WALL?
> 
>  or MAINS?

Philipp, much thanks! MAINS indeed feels perfect for that.

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2
