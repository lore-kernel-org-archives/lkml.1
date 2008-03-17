Return-Path: <linux-kernel-owner+w=401wt.eu-S1752792AbYCQQYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbYCQQYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 12:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbYCQQYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 12:24:11 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51138 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751736AbYCQQYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 12:24:10 -0400
Date: Mon, 17 Mar 2008 16:07:39 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: ultrastor.c is a bit-rot
Message-ID: <20080317160739.04ad0939@core>
In-Reply-To: <47DE8736.8020405@panasas.com>
References: <47DE8736.8020405@panasas.com>
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

> if the machine has more then 2^24 of memory. Then this will never
> work, right? or I'm missing it completely?

It will work compiled in, and probably users of such cards if any don't
have > 16MB. I doubt anyone is using the driver however.

Alan
