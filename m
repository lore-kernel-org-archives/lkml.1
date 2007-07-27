Return-Path: <linux-kernel-owner+w=401wt.eu-S1764635AbXG0SrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764635AbXG0SrE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 14:47:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758486AbXG0Sqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 14:46:54 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4560 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758228AbXG0Sqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 14:46:53 -0400
Date: Fri, 27 Jul 2007 18:46:17 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Lars Ellenberg <lars.ellenberg@linbit.com>,
       Jan Engelhardt <jengelh@computergmbh.de>, Jens Axboe <axboe@kernel.dk>,
       Andrew Morton <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [DRIVER SUBMISSION] DRBD wants to go mainline
Message-ID: <20070727184617.GF11895@ucw.cz>
References: <20070721203819.GA10706@mail.linbit.com> <Pine.LNX.4.64.0707212316530.21737@fbirervta.pbzchgretzou.qr> <20070721224300.GB18326@mail.linbit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070721224300.GB18326@mail.linbit.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > >We implement shared-disk semantics in a shared-nothing cluster.
> > 
> > If nothing is shared, the disk is not shared, but got shared-disk
> > semantics? A little confusing.
> 
> Think of it as RAID1 over TCP.
> Typically you have one Node in Primary, the other as Secondary,
> replication target only.

I guess TCP means people should not swap over it?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
