Return-Path: <linux-kernel-owner+w=401wt.eu-S939359AbXG3Tls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939359AbXG3Tls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 15:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935986AbXG3Tlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 15:41:39 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:50418 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936623AbXG3Tli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 15:41:38 -0400
Date: Mon, 30 Jul 2007 21:41:37 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Lars Ellenberg <lars.ellenberg@linbit.com>
cc: Pavel Machek <pavel@ucw.cz>, Jens Axboe <axboe@kernel.dk>,
       Andrew Morton <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [DRIVER SUBMISSION] DRBD wants to go mainline
In-Reply-To: <20070730192954.GA7363@localhost>
Message-ID: <Pine.LNX.4.64.0707302140440.26373@fbirervta.pbzchgretzou.qr>
References: <20070721203819.GA10706@mail.linbit.com>
 <Pine.LNX.4.64.0707212316530.21737@fbirervta.pbzchgretzou.qr>
 <20070721224300.GB18326@mail.linbit.com> <20070727184617.GF11895@ucw.cz>
 <20070730192954.GA7363@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 30 2007 21:35, Lars Ellenberg wrote:
>On Fri, Jul 27, 2007 at 06:46:17PM +0000, Pavel Machek wrote:
>> Hi!
>> 
>> > > >We implement shared-disk semantics in a shared-nothing cluster.
>> > > 
>> > > If nothing is shared, the disk is not shared, but got shared-disk
>> > > semantics? A little confusing.
>> > 
>> > Think of it as RAID1 over TCP.

Getting back at that... How does it compare (in terms of "do we need it?")
to RAIF1 over NFS?


	Jan
-- 
