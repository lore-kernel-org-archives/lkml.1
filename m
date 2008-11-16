Return-Path: <linux-kernel-owner+w=401wt.eu-S1753419AbYKPSay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbYKPSay (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 13:30:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbYKPSak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 13:30:40 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51344 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751338AbYKPSai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 13:30:38 -0500
Date: Sun, 16 Nov 2008 18:29:53 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>
Subject: Re: 2.6.28-rc5: Reported regressions from 2.6.27
Message-ID: <20081116182953.6231ae8c@lxorguk.ukuu.org.uk>
In-Reply-To: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera>
References: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera>
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

>      the majority of these patches have not been merged for over two weeks
>      (for almost three weeks in many cases and for over a _month_ in one case).
>      IMO, this is insane.]

Some of them are quite serious too - some stuff is basically unusable in
2.6.28rc due to the vmalloc bug.

Is there any reason why someone (Rafael ?) shouldn't simply submit all of
those patches that look sensible, are reported to fix regressions and
whose maintainer has not provided a reason to NOT apply them into the
tree ?

Alan

