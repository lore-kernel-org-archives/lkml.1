Return-Path: <linux-kernel-owner+w=401wt.eu-S1756844AbYHNUZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844AbYHNUZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 16:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbYHNUY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 16:24:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43608 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751655AbYHNUY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 16:24:56 -0400
Date: Thu, 14 Aug 2008 21:06:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@suse.cz>
Cc: tvrtko.ursulin@sophos.com, Arjan van de Ven <arjan@infradead.org>,
       Adrian Bunk <bunk@kernel.org>, davecb@sun.com, Greg KH <greg@kroah.com>,
       "Press, Jonathan" <Jonathan.Press@ca.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, malware-list@lists.printk.net,
       Mihai Don??u <mdontu@bitdefender.com>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon
 access scanning
Message-ID: <20080814210604.7bdea3ea@lxorguk.ukuu.org.uk>
In-Reply-To: <20080814125613.GB2262@elf.ucw.cz>
References: <20080813065401.1bbdcb07@infradead.org>
	<20080813141618.696833764EA@pmx1.sophos.com>
	<20080814125613.GB2262@elf.ucw.cz>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > LD_PRELOAD does not solve at least knfsd and suid binaries. But we are 
> > going in circles. :)
> 
> Yes, there are about 5 suid binaries on typical linux system. Link
> them to libmalware by hand

And knfsd ?

Oh yes you don't seem to have an answer just manure to throw
