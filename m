Return-Path: <linux-kernel-owner+w=401wt.eu-S1764611AbXLTWIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764611AbXLTWIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 17:08:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764303AbXLTWHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 17:07:49 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44803 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764196AbXLTWHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 17:07:47 -0500
Date: Thu, 20 Dec 2007 21:54:11 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@shadowen.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, trivial@kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>
Subject: Re: Trailing periods in kernel messages
Message-ID: <20071220215411.183d03c0@the-village.bc.nu>
In-Reply-To: <1198186984.6183.72.camel@localhost>
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

> Documentation/Coding Style
> 
> 		Chapter 13: Printing kernel messages
> 
> Kernel messages do not have to be terminated with a period.


This piece of the document is wrong. It should also be changed. I've no
idea how such a ludicrous statement ever got into the Coding Style but I
have never seen it discussed and an archive search suggests it just
sneaked in without any kind of approval and discussion the list.

Kernel messages are in English. Let us keep it that way. Missing
punctuation is equated by many parts of the English speaking world with
poor quality, sloppy products and low levels of education. These are not
things with which we wish to be associated IMHO.

NAK to the patch.

Alan
