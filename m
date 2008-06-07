Return-Path: <linux-kernel-owner+w=401wt.eu-S1762734AbYFGQzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762734AbYFGQzJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 12:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759762AbYFGQy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 12:54:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39011 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759565AbYFGQyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 12:54:55 -0400
Date: Sat, 7 Jun 2008 09:51:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <greg@kroah.com>
cc: Chris Wright <chrisw@sous-sol.org>, Tejun Heo <htejun@gmail.com>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, matthieu.castet@parrot.com,
       Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
       akpm@linux-foundation.org, Chuck Wolber <chuckw@quantumlinux.com>,
       stable@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 10/50] libata: force hardreset if link is in
 powersave mode
In-Reply-To: <20080607015730.GA15123@kroah.com>
Message-ID: <alpine.LFD.1.10.0806070951430.3473@woody.linux-foundation.org>
References: <20080607010215.358296706@sous-sol.org> <20080607010555.470605116@sous-sol.org> <alpine.LFD.1.10.0806061826420.3473@woody.linux-foundation.org> <20080607015730.GA15123@kroah.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 6 Jun 2008, Greg KH wrote:
> > 
> > This isn't upstream. Maybe there's some reason it's not needed upstream, 
> > but it would be nice to know.
> 
> To quote Tejun when he sent this patch:
> 	---
> 	Patch for -stable only.  Devel branch now uses hardreset by
> 	default so this type of promotion logic isn't necessary anymore.

Ok, thanks,

		Linus
