Return-Path: <linux-kernel-owner+w=401wt.eu-S1751613AbXE2WoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613AbXE2WoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 18:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbXE2Wny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 18:43:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36545
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751123AbXE2Wny (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 18:43:54 -0400
Date: Tue, 29 May 2007 15:44:06 -0700 (PDT)
Message-Id: <20070529.154406.104042418.davem@davemloft.net>
To: michal.k.k.piotrowski@gmail.com
Cc: iank@bredband.net, Linux-kernel@vger.kernel.org
Subject: Re: [BUG] Something goes wrong with timer statistics.
From: David Miller <davem@davemloft.net>
In-Reply-To: <6bffcb0e0705291541q7e6d6faen5cd6345074c4c92a@mail.gmail.com>
References: <1180474738.22497.25.camel@pi.pomac.com>
	<20070529.153723.108751260.davem@davemloft.net>
	<6bffcb0e0705291541q7e6d6faen5cd6345074c4c92a@mail.gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Date: Wed, 30 May 2007 00:41:46 +0200

> On 30/05/07, David Miller <davem@davemloft.net> wrote:
> > From: Ian Kumlien <iank@bredband.net>
> > Date: Tue, 29 May 2007 23:38:48 +0200
> >
> > > As the daystar sets, i try to play some with my new would be
> > > firewall/server, but since this will be running for quite some time i
> > > have been experimenting with powertop to find out what i can do to limit
> > > it's power usage.
> > >
> > > But, if i run powertop for too long or a few times to many... this
> > > happens:
> > > http://pomac.netswarm.net/pics/kernel_panic.jpg
> > >
> > > If i don't run powertop, it is rock solid... Compiling for hours,
> > > running memtest for hours etc etc...
> >
> > I see this same exact problem on sparc64.
> 
> Have you tried this patch?
> http://lkml.org/lkml/2007/5/29/392

Of course, I worked with Thomas on the fix :-)
