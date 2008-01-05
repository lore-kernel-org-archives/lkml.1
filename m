Return-Path: <linux-kernel-owner+w=401wt.eu-S1757411AbYAEUI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411AbYAEUI4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 15:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756212AbYAEUIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 15:08:47 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39643 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756189AbYAEUIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 15:08:46 -0500
Date: Sat, 5 Jan 2008 20:06:15 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: 2.6.24-rc6-git12: Reported regressions from 2.6.23
Message-ID: <20080105200615.45236ffb@lxorguk.ukuu.org.uk>
In-Reply-To: <200801052042.56042.rjw@sisk.pl>
References: <200801052042.56042.rjw@sisk.pl>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject		: PATA_HPT37X embezzles two ports
> Submitter	: "Bjoern Olausson" <lkmlist@gmail.com>
> Date		: 2007-12-12 11:05
> References	: http://lkml.org/lkml/2007/12/12/161
> 		  http://bugzilla.kernel.org/show_bug.cgi?id=9551

HPT374 patch was posted.

We also have a newly reported regression in USB pl2303

See [pl2303 regression] Linux 2.6.23 breaks gpsbabel's DG-100 support on
linux-usb@vger.kernel.org

No bug # yet but will try and sort a patch out next week.
