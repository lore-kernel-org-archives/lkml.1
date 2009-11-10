Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400AbZKJMeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbZKJMeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 07:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbZKJMeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 07:34:25 -0500
Received: from ns.penguin.cz ([84.21.108.25]:58199 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864AbZKJMeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 07:34:24 -0500
Subject: Re: spitz battery driver
From: Stanislav Brabec <utx@penguin.cz>
To: Pavel Machek <pavel@ucw.cz>
Cc: Eric Miao <eric.y.miao@gmail.com>, zaurus-devel@www.linuxtogo.org,
       rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com,
       Paul Fertser <fercerpav@gmail.com>
In-Reply-To: <20091110104634.GA1395@ucw.cz>
References: <20091109135813.GA1385@ucw.cz>
	 <f17812d70911091948p5331f11djc887443559b233db@mail.gmail.com>
	 <20091110104634.GA1395@ucw.cz>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 10 Nov 2009 13:34:24 +0100
Message-Id: <1257856464.6394.6.camel@utx.utx.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Tue 2009-11-10 11:48:16, Eric Miao wrote:

> > > This introduces battery driver for spitz. For now it is
> > > monitoring&debug-only.
> > >
> > 
> > This is a good move. However, I assume the patch is still RFC now.
> > Or basically the coding style cleanup can be separated into another
> > patch?
> 
> Its rfc now. Parts of codingstyle cleanup should already be in your
> tree, I'll rediff it later.

Pavel, could you compare your patch with the "power: implement platform
battery driver"﻿ patches from Paul Fertser just sent to LKML and
zaurus-devel list? Would it be complicated to migrate to it? I guess
that use of platform driver could allow to recycle major parts of the
charging driver by more devices.


________________________________________________________________________
Stanislav Brabec
http://www.penguin.cz/~utx/zaurus

