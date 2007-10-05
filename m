Return-Path: <linux-kernel-owner+w=401wt.eu-S1763605AbXJEUrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763605AbXJEUrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 16:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761008AbXJEUrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 16:47:09 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52943 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760813AbXJEUrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 16:47:08 -0400
Date: Fri, 5 Oct 2007 21:51:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Mike Robak" <mrobak@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: libATA error message doc
Message-ID: <20071005215147.42bdc01d@the-village.bc.nu>
In-Reply-To: <p737im15q8s.fsf@bingen.suse.de>
References: <2b40bfd30710031039y70252a8bk898b102c993a92af@mail.gmail.com>
	<20071003192453.0ed967f1@the-village.bc.nu>
	<p737im15q8s.fsf@bingen.suse.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I always found that quite convenient. Putting at least a summary in Documentation
> would probably user-friendly. It tends to be hard to find stuff in specifications,
> especially if you're not very familiar with the standard.

There are over 100 commands, and the status bits can only be read in
combination and according to some interpretation rules - it would be
quite a long document. The standards are also all publically available in
this case, albeit not neccessarily the most interesting read

AFAIK there is a patch queued to print some of the data in a more user
friendly format.
