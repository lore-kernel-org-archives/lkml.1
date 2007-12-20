Return-Path: <linux-kernel-owner+w=401wt.eu-S1761465AbXLTXuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761465AbXLTXuc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 18:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757327AbXLTXuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 18:50:16 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55585 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757173AbXLTXuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 18:50:15 -0500
Date: Thu, 20 Dec 2007 23:40:24 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: joe@perches.com, apw@shadowen.org, lizf@cn.fujitsu.com, elendil@planet.nl,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, trivial@kernel.org,
       rdunlap@xenotime.net, jschopp@austin.ibm.com
Subject: Re: Trailing periods in kernel messages
Message-ID: <20071220234024.3d357f5a@the-village.bc.nu>
In-Reply-To: <20071220141928.a49eba7b.akpm@linux-foundation.org>
References: <474E6BD0.20103@cn.fujitsu.com>
	<E1IxfE8-0000Sr-9w@faramir.fjphome.nl>
	<474E8669.6060409@cn.fujitsu.com>
	<200711291120.19595.elendil@planet.nl>
	<20071129032036.4c021617.akpm@linux-foundation.org>
	<474F6372.70705@cn.fujitsu.com>
	<1196386259.22120.101.camel@localhost>
	<474F6D4D.9010006@cn.fujitsu.com>
	<1196390128.22120.118.camel@localhost>
	<20071220162923.GB27885@shadowen.org>
	<20071220210741.6dc3caf5@the-village.bc.nu>
	<1198186984.6183.72.camel@localhost>
	<20071220215411.183d03c0@the-village.bc.nu>
	<20071220141928.a49eba7b.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> For the record, I won't be taking any "add period to printk" patches.

> akpm:/usr/src/linux-2.6.24-rc5> grep -r '[^\.]\\n"' net | wc -l
> 4978
> akpm:/usr/src/linux-2.6.24-rc5> grep -r '[\.]\\n"' net | wc -l 
> 493
> 
> Send 'em to Dave!

I was assuming they would go to the trivial patches maintainer, that's
what the poor man is there for.

Alan
