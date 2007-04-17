Return-Path: <linux-kernel-owner+w=401wt.eu-S965052AbXDQPXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965052AbXDQPXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 11:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754467AbXDQPXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 11:23:15 -0400
Received: from smtp23.orange.fr ([80.12.242.50]:28775 "EHLO smtp23.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462AbXDQPXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 11:23:14 -0400
X-ME-UUID: 20070417152312628.9977D1C0009A@mwinf2302.orange.fr
Subject: Re: ZFS with Linux: An Open Plea
From: Xavier Bestel <xavier.bestel@free.fr>
To: Ricardo Correia <linux-kernel@wizy.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Tomasz K?oczko <kloczek@rudy.mif.pg.gda.pl>,
       Theodore Tso <tytso@mit.edu>, "David R. Litwin" <presently42@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4624E275.7000705@wizy.org>
References: <op.tqw1g6n0ftfxs2@localhost.localdomain>
	 <20070417131045.GB18373@thunk.org>
	 <Pine.BSO.4.63.0704171527150.11088@rudy.mif.pg.gda.pl>
	 <20070417154814.632da1d9@the-village.bc.nu>  <4624E275.7000705@wizy.org>
Content-Type: text/plain
Date: Tue, 17 Apr 2007 17:23:05 +0200
Message-Id: <1176823385.14404.28.camel@frg-rhel40-em64t-04>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-17 at 16:06 +0100, Ricardo Correia wrote:
> Alan Cox wrote:
> > The real test of whether Sun were serious about ZFS being anywhere but
> > Solaris is what they do to license it - they've patented everything they
> > can, and made the code available only under licenses incompatible with
> > other OS products. Their intent is quite clear, and quite sad.
> 
> That is not quite true. They made ZFS available under the CDDL, which is
> an OSI-approved open-source license that is *less* restrictive than the
> GPL. The CDDL doesn't prevent anyone from using the ZFS code in
> combination with code under other licenses.

You are wrong. Please read e.g.
<http://www.gnu.org/licenses/license-list.html#GPLIncompatibleLicenses>
(maybe there are better analysis somewhere, but I don't know where).

	Xav


