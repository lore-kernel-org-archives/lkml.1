Return-Path: <linux-kernel-owner+w=401wt.eu-S1753451AbXKSMbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbXKSMbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 07:31:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbXKSMbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 07:31:25 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50384 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751875AbXKSMbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 07:31:24 -0500
Date: Mon, 19 Nov 2007 12:29:36 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: raju@linux-delhi.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: Query on kernel metrics available
Message-ID: <20071119122936.6e209a18@the-village.bc.nu>
In-Reply-To: <200711191259.26502.raju@linux-delhi.org>
References: <200711191259.26502.raju@linux-delhi.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2007 12:59:26 +0530
Raj Mathur <raju@linux-delhi.org> wrote:

> A competing OS vendor is claiming that the Linux kernel has no way to 
> measure the following:
> 
> a. Time spent waiting for page faults in percent
> 
> b. Total transfer time for each auxiliary memory in percent
> 
> c. Time in percent when one or more tasks were blocked waiting for 
> memory resources
> 
> d. Time spent waiting for page faults in percent

a an d appear to be the same thing

> I was wondering if the claims were pure FUD or are measurements 
> possible -- whether they are actually implemented or not is not 
> important (at least at this stage).  Apologies if the descriptions 
> aren't very precise; OTOH that leaves us room to interpret the claims 
> in a favourable (to us) manner :)

Systemtap as shipped by most of the enterprise vendors can measure all of
this quite easily. 

Alan
