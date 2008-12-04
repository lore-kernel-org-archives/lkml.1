Return-Path: <linux-kernel-owner+w=401wt.eu-S1757603AbYLDAON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603AbYLDAON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 19:14:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756597AbYLDALD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 19:11:03 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47157 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759426AbYLDALA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 19:11:00 -0500
Date: Thu, 4 Dec 2008 00:10:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, rusty@rustcorp.com.au,
       rmk+lkml@arm.linux.org.uk, linux-kernel@vger.kernel.org,
       sfr@canb.auug.org.au
Subject: Re: Yet more ARM breakage in linux-next
Message-ID: <20081204001032.39d2a281@lxorguk.ukuu.org.uk>
In-Reply-To: <20081203154629.bba4e5e4.akpm@linux-foundation.org>
References: <20081203192905.GA12502@flint.arm.linux.org.uk>
	<20081203124109.79f8f15b.akpm@linux-foundation.org>
	<200812040952.44957.rusty@rustcorp.com.au>
	<49371848.2080804@oracle.com>
	<20081203154629.bba4e5e4.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> For some reason, the act of typing in some kerneldoc makes people's
> brains turn off.  Perhaps it's because "oh, I am supposed to type some
> documentation here" instead of "gee, I think this code is unclear,
> let's clarify that".

Well prior to the kerneldoc stuff they didn't type anything at all to
clarify or document. Also kerneldoc is meant for documenting the APIs not
so much the internals of functions. When used sensibly it can be very
useful, especially if it documents API locking rules.

Alan
