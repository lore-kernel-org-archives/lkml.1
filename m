Return-Path: <linux-kernel-owner+w=401wt.eu-S1756555AbYCUL3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555AbYCUL3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 07:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbYCUL2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 07:28:55 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35068 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752932AbYCUL2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 07:28:54 -0400
Date: Fri, 21 Mar 2008 11:13:13 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Peter F. Patel-Schneider" <pfps@verizon.net>
Cc: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org,
       "Peter F. Patel-Schneider" <pfps@research.bell-labs.com>
Subject: Re: 2.6.23-rc9-git4: pata_pcmcia, disabling IRQ #9 and Re: libata
 and legacy ide pcmcia failure
Message-ID: <20080321111313.24567b9f@core>
In-Reply-To: <47E39963.2090908@verizon.net>
References: <47067DB9.80200@roarinelk.homelinux.net>
	<47E300B2.7000104@verizon.net>
	<20080321011205.4c7b4a61@core>
	<47E31197.70003@gmail.com>
	<20080321104002.27a7d19e@core>
	<47E39963.2090908@verizon.net>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> How can I check to see if this is the case?  How would this explain that 

As I said before, take a CF card/adapter combination you know fails
on a T60p/T61p and test it on a Linux box that isn't one of those types
(and preferably not a Lenovo at all)

> the adapter and card sometimes work when they are in when the system boots?

Ask the BIOS authors. Trying to fathom what they have done is frequently
interesting. Everyone else I've had do this has found the card works
perfectly with Linux except in the Lenovo box.

Alan
