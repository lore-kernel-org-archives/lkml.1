Return-Path: <linux-kernel-owner+w=401wt.eu-S1757256AbXK1ULC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbXK1ULC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 15:11:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755355AbXK1UKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 15:10:53 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51139 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753560AbXK1UKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 15:10:52 -0500
Date: Wed, 28 Nov 2007 20:07:16 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: ata4294967295: failed to start port (errno=-19)
Message-ID: <20071128200716.14eccfdd@the-village.bc.nu>
In-Reply-To: <Pine.SOC.4.64.0711281947090.15823@math.ut.ee>
References: <Pine.SOC.4.64.0711281947090.15823@math.ut.ee>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This message comes from 2.6.24-rc3 + todays git, version 
> a531a141089714efe39eca89593524fdf05104f2. I did grep the logs and found 
> that it first appeared in 2.6.24-rc1 (+ some git mayve) on Nov 3. 
> I used 2.6.23 before that and it did not show this message.

Can you stick a stack trace in at that point ? That would help diagnose
it a great deal quicker.
