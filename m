Return-Path: <linux-kernel-owner+w=401wt.eu-S1755150AbYHRPv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150AbYHRPv3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 11:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbYHRPvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 11:51:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58953 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754774AbYHRPvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 11:51:17 -0400
Date: Mon, 18 Aug 2008 16:33:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Jan Harkes <jaharkes@cs.cmu.edu>,
       Rik van Riel <riel@redhat.com>,
       "Press, Jonathan" <Jonathan.Press@ca.com>, peterz@infradead.org,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       hch@infradead.org, andi@firstfloor.org, viro@ZenIV.linux.org.uk
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
Message-ID: <20080818163313.72927af7@lxorguk.ukuu.org.uk>
In-Reply-To: <1219015177.27389.1.camel@localhost.localdomain>
References: <1218645375.3540.71.camel@localhost.localdomain>
	<20080813172437.3ed90b0d@lxorguk.ukuu.org.uk>
	<1218646065.3540.75.camel@localhost.localdomain>
	<20080813173722.13c9c306@lxorguk.ukuu.org.uk>
	<1218646833.3540.82.camel@localhost.localdomain>
	<20080813205906.559d3f37@lxorguk.ukuu.org.uk>
	<2629CC4E1D22A64593B02C43E855530304AE4BC2@USILMS12.ca.com>
	<20080813173529.7069b5f1@cuia.bos.redhat.com>
	<20080815201622.GD31584@cs.cmu.edu>
	<20080815150509.20ffb91d@infradead.org>
	<1219015177.27389.1.camel@localhost.localdomain>
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

> I could probably buy that, but I don't know how an HSM would work.
> Would we have everything we need at open for them to fire off?
> 
> /me is HSM clueless and trying to include their needs is proving a
> challenge.

So don't bother. Its a theoretical use for the most part so we can mangle
the interface later. 

Alan
