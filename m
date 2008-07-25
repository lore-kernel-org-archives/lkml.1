Return-Path: <linux-kernel-owner+w=401wt.eu-S1756696AbYGYLxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbYGYLxo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 07:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbYGYLxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 07:53:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60221 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752414AbYGYLxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 07:53:33 -0400
Date: Fri, 25 Jul 2008 12:35:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: IDE/ATA development list <linux-ide@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: libata-dev.git clean up and branch status
Message-ID: <20080725123510.183f65f8@lxorguk.ukuu.org.uk>
In-Reply-To: <468EDC76.9050708@garzik.org>
References: <468EDC76.9050708@garzik.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> mv-ahci-pata	Marvell 6121/6141 AHCI clone PATA support
> 		Parent: mv-ahci
> 		Status: Need to update for proper use of PATA
> 			controller commands (provides direct access to
> 			PATA device shadow registers)

What is the status on this - we've now had the regression where you
can't use all of a marvell chip for over 6 months ?

Alan
