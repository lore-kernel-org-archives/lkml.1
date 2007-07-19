Return-Path: <linux-kernel-owner+w=401wt.eu-S1765475AbXGSNJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765475AbXGSNJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756486AbXGSNJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:09:29 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53368 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756149AbXGSNJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:09:27 -0400
Date: Thu, 19 Jul 2007 14:15:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Scott Preece" <sepreece@gmail.com>
Cc: "James Morris" <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
       "Christian Ehrhardt" <lk@c--e.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Chris Wright" <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       "Stephen Smalley" <sds@tycho.nsa.gov>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [PATCH try #3] security: Convert LSM into a static interface
Message-ID: <20070719141535.4a9c8581@the-village.bc.nu>
In-Reply-To: <7b69d1470707190556n78e52232y7dfea1fd6f47ced@mail.gmail.com>
References: <Line.LNX.4.64.0707141233490.26711@d.namei>
	<20070718183503.541026f8.akpm@linux-foundation.org>
	<20070719073948.GI18840@lisa.in-ulm.de>
	<20070719122424.GA5186@vino.hallyn.com>
	<Line.LNX.4.64.0707190832290.4303@d.namei>
	<7b69d1470707190556n78e52232y7dfea1fd6f47ced@mail.gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Please distinguish between "cater to" and "support". If the kernel
> didn't worry about supporting out-of-tree code, then why would there
> be loadable module at all?

Memory usage, flexibility, debugging.

Module support was not added for external modules.
