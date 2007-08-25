Return-Path: <linux-kernel-owner+w=401wt.eu-S933968AbXHYJru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933968AbXHYJru (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 05:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763007AbXHYJrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 05:47:42 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45110 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754613AbXHYJrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 05:47:41 -0400
Date: Sat, 25 Aug 2007 10:55:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: TheOneKEA <theonekea@gmail.com>
Cc: "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: Possible problems reading a DVD-RAM disc
Message-ID: <20070825105552.0b762e1e@the-village.bc.nu>
In-Reply-To: <443c85430708241806y4730bb15n9094fed2e51437f3@mail.gmail.com>
References: <fa.pKJ1f/uGrEIrPt+FdyZwKxvM2Ws@ifi.uio.no>
	<46CF6B71.7030001@shaw.ca>
	<443c85430708241806y4730bb15n9094fed2e51437f3@mail.gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Not sure why it would be writing to the disc though.. Maybe if the disc
> > is mounted read-write it is doing last-access-time updates or something?
> 
> It's possible - I didn't explicitly specify noatime when mounting the
> volume; does the vfat kernel module honor the noatime option?

And more generally mounting readonly 
