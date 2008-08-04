Return-Path: <linux-kernel-owner+w=401wt.eu-S1757590AbYHDWdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590AbYHDWdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 18:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbYHDWdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 18:33:15 -0400
Received: from senator.holtmann.net ([87.106.208.187]:52020 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbYHDWdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 18:33:14 -0400
Subject: Re: pull request: wireless-2.6 2008-08-04
From: Marcel Holtmann <marcel@holtmann.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080804215439.GA9658@tuxdriver.com>
References: <20080804193753.GA30345@tuxdriver.com>
	 <1217882288.7819.19.camel@californication>
	 <20080804204558.GA5866@tuxdriver.com>
	 <1217886123.7819.23.camel@californication>
	 <20080804215439.GA9658@tuxdriver.com>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 00:37:06 +0200
Message-Id: <1217889426.7819.26.camel@californication>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

> > > > > Luis R. Rodriguez (4):
> > > > >       list.h: Add list_splice_tail() and list_splice_tail_init()
> > > > >       list.h: add list_cut_position()
> > > > 
> > > > have these two changes got reviewed on LKML? I don't see any ACKs for it
> > > > in the commit message.
> > > 
> > > Hmmm...no.  I thought the original patches had been copied to
> > > linux-kernel, but it looks like that is not the case.
> > > 
> > > The original patches are archived here:
> > > 
> > > 	http://marc.info/?l=linux-wireless&m=121783421908441&w=2
> > > 
> > > 	http://marc.info/?l=linux-wireless&m=121783422008445&w=2
> > > 
> > > What problems do you see with them?
> > 
> > I don't see a problem with these patches, but they should at least be
> > reviewed on LKML once. Changes to core kernel infrastructure should not
> > be merged silently via subsystem trees without any kind of ACKs.
> 
> Yes, fine.  That wasn't my intent. :-)  The patches were originally
> posted about two weeks ago, too bad that didn't actually go to
> linux-kernel. :-(

just post them to LKML (or let Luis do it) so they get reviewed. I
really don't see an issue with them, but that is only me.

Regards

Marcel


