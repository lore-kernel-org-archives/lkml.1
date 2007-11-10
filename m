Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbXKJUCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbXKJUCo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 15:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbXKJUCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 15:02:36 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38892 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753451AbXKJUCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 15:02:35 -0500
Date: Sat, 10 Nov 2007 20:02:05 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-am33-list@redhat.com
Subject: Re: [PATCH 5/6] MN10300: Add the MN10300/AM33 architecture to the
 kernel [try #5]
Message-ID: <20071110200205.1b0a72d7@the-village.bc.nu>
In-Reply-To: <20071110114320.1fa6e94c.akpm@linux-foundation.org>
References: <20071109195303.edbdc631.akpm@linux-foundation.org>
	<20071109153432.20803.69832.stgit@warthog.procyon.org.uk>
	<20071109153458.20803.10594.stgit@warthog.procyon.org.uk>
	<24343.1194697130@redhat.com>
	<20071110114320.1fa6e94c.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> If it is indeed the case that this architecture is used internally by a
> single organisation then perhaps it doesn't make sense for us to merge it.

Disagree, as does history. We merged the AP1000 ... 

> distribution: to get it into the hands of people who need it.  But in this
> situation there is no advantage to *anyone* from this merge apart from MEI.

Or anyone who wants to hack an MEI device. If just three people do then
it beats voyager ;)

Alan
