Return-Path: <linux-kernel-owner+w=401wt.eu-S1765141AbYBVKPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765141AbYBVKPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 05:15:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbYBVKPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 05:15:31 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60380 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752934AbYBVKP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 05:15:28 -0500
Date: Fri, 22 Feb 2008 10:04:35 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Roland Dreier <rdreier@cisco.com>,
       Glenn Streiff <gstreiff@NetEffect.com>,
       Faisal Latif <flatif@NetEffect.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: Merging of completely unreviewed drivers
Message-ID: <20080222100435.12616d92@core>
In-Reply-To: <m3k5kxq2ih.fsf@maximus.localdomain>
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2>
	<5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2>
	<20080221154951.GA28328@cs181133002.pp.htv.fi>
	<adahcg2awag.fsf@cisco.com>
	<20080221210124.GD28328@cs181133002.pp.htv.fi>
	<alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org>
	<m3tzk1q3rt.fsf@maximus.localdomain>
	<47BE0C12.604@garzik.org>
	<m3k5kxq2ih.fsf@maximus.localdomain>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2008 01:05:26 +0100
Krzysztof Halasa <khc@pm.waw.pl> wrote:

> Jeff Garzik <jeff@garzik.org> writes:
> 
> > If a driver is full of lines of length >80, that's a problem.
> 
> I'm not sure.
> We all have more than 80-chars wide displays for years, don't we? The

Even a vt132 serial terminal or later can do 132. Decades not years.
