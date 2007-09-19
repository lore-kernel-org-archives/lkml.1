Return-Path: <linux-kernel-owner+w=401wt.eu-S1761524AbXISQcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761524AbXISQcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 12:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756424AbXISQcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 12:32:14 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46463 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758637AbXISQcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 12:32:13 -0400
Date: Wed, 19 Sep 2007 17:39:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Miller <davem@davemloft.net>
Cc: drepper@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: follow-up: discrepancy with POSIX
Message-ID: <20070919173904.3987ec1b@the-village.bc.nu>
In-Reply-To: <20070919.091510.00787167.davem@davemloft.net>
References: <46F13E8B.4050309@redhat.com>
	<20070919.091510.00787167.davem@davemloft.net>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007 09:15:10 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Ulrich Drepper <drepper@redhat.com>
> Date: Wed, 19 Sep 2007 08:21:47 -0700
> 
> > If you think the POSIX spec is wrong (and can point to other
> > implementations doing the same as Linux) let me know and I'll work on
> > getting the spec changed.
> 
> The whole AF_UNSPEC thing I'm almost certain comes from BSD, which has
> behaved that way for centuries.

We got it from the 1003.4g draft socket specification if I remember
rightly. Its entirely plausible that got it from 4BSE.

Alan
