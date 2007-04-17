Return-Path: <linux-kernel-owner+w=401wt.eu-S932409AbXDQPGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbXDQPGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 11:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932386AbXDQPGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 11:06:36 -0400
Received: from relay2.ptmail.sapo.pt ([212.55.154.22]:56133 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932409AbXDQPGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 11:06:34 -0400
X-AntiVirus: PTMail-AV 0.3-0.90.1
Message-ID: <4624E275.7000705@wizy.org>
Date: Tue, 17 Apr 2007 16:06:29 +0100
From: Ricardo Correia <linux-kernel@wizy.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: =?ISO-8859-1?Q?Tomasz_K=3Foczko?= <kloczek@rudy.mif.pg.gda.pl>,
       Theodore Tso <tytso@mit.edu>, "David R. Litwin" <presently42@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: ZFS with Linux: An Open Plea
References: <op.tqw1g6n0ftfxs2@localhost.localdomain>	<20070417131045.GB18373@thunk.org>	<Pine.BSO.4.63.0704171527150.11088@rudy.mif.pg.gda.pl> <20070417154814.632da1d9@the-village.bc.nu>
In-Reply-To: <20070417154814.632da1d9@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> The real test of whether Sun were serious about ZFS being anywhere but
> Solaris is what they do to license it - they've patented everything they
> can, and made the code available only under licenses incompatible with
> other OS products. Their intent is quite clear, and quite sad.

That is not quite true. They made ZFS available under the CDDL, which is
an OSI-approved open-source license that is *less* restrictive than the
GPL. The CDDL doesn't prevent anyone from using the ZFS code in
combination with code under other licenses.

The proof of that is that ZFS has already been ported to FreeBSD and
it's being ported to the Mac OS X kernel.

The main problem with ZFS on Linux is that most people consider that the
GPL doesn't allow non-GPL kernel modules.
