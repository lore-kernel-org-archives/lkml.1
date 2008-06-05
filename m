Return-Path: <linux-kernel-owner+w=401wt.eu-S1757491AbYFEJ6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbYFEJ6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 05:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756826AbYFEJzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 05:55:48 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:32874 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756883AbYFEJzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 05:55:21 -0400
Date: Thu, 5 Jun 2008 11:55:20 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Jens Axboe <jens.axboe@oracle.com>
cc: Fausto Richetti Blanco <fausto.blanco@gmail.com>,
       linux-kernel@vger.kernel.org, miquels@cistron.nl, riel@redhat.com
Subject: Re: Pipe buffers' limit of 16 * 4K
In-Reply-To: <20080530103531.GT25504@kernel.dk>
Message-ID: <alpine.LNX.1.10.0806051155070.29055@fbirervta.pbzchgretzou.qr>
References: <d8d698ae0805231255i4d0da724p68cb2b9376134797@mail.gmail.com> <d8d698ae0805231719g4202edf2k947bba4128385ab6@mail.gmail.com> <20080523205630.444fe2b9@bree.surriel.com> <d8d698ae0805261043u125b653ve73d067cd92caa16@mail.gmail.com>
 <d8d698ae0805290600s782e16b4pe70d725f55826cf0@mail.gmail.com> <1212067164.8621.3.camel@localhost.localdomain> <alpine.LNX.1.10.0805291633000.19264@fbirervta.pbzchgretzou.qr> <d8d698ae0805290846w7cd2b14j99db2e1e2a9ec7ed@mail.gmail.com>
 <20080530103531.GT25504@kernel.dk>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2008-05-30 12:35, Jens Axboe wrote:
>
>I have an old patch that does that, I just looked it up and it was last
>updated for 2.6.23. It uses fcntl() with F_SETPIPE_SZ for getting and
>setting the pipe size.
>
>Patch updated, the below is the current Linus kernel.

Can you merge it?

