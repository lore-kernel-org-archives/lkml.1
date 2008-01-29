Return-Path: <linux-kernel-owner+w=401wt.eu-S933734AbYA2RRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933734AbYA2RRK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 12:17:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762938AbYA2RQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 12:16:53 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60065 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753833AbYA2RQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:16:51 -0500
Date: Tue, 29 Jan 2008 17:12:19 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: rgheck <rgheck@bobjweil.com>
Cc: Daniel Barkalow <barkalow@iabervon.org>,
       Gene Heskett <gene.heskett@gmail.com>, Zan Lynx <zlynx@acm.org>,
       Calvin Walton <calvin.walton@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux ide Mailing list <linux-ide@vger.kernel.org>
Subject: Re: Problem with ata layer in 2.6.24
Message-ID: <20080129171219.53a8efed@core>
In-Reply-To: <479F5D29.1020705@bobjweil.com>
References: <200801272122.21823.gene.heskett@gmail.com>
	<1201539043.31293.7.camel@zem>
	<1201540830.6526.19.camel@localhost>
	<200801281230.32910.gene.heskett@gmail.com>
	<alpine.LNX.1.00.0801281248190.13593@iabervon.org>
	<479E1D9E.3000900@bobjweil.com>
	<20080129121201.2f727f5f@core>
	<479F5D29.1020705@bobjweil.com>
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

  
> Is this >4GB or >=4GB? I've seen contradictory reports, and I've got 4GB.

Depends how the memory is mapped. Any memory physically above the 4GB
boundary

Alan
