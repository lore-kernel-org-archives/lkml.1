Return-Path: <linux-kernel-owner+w=401wt.eu-S1758854AbXEWVdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854AbXEWVdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 17:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756675AbXEWVc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 17:32:56 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37629 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756520AbXEWVcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 17:32:55 -0400
Date: Wed, 23 May 2007 22:35:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robert Hancock <hancockr@shaw.ca>,
       Olivier Galibert <galibert@pobox.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI
 motherboard resources
Message-ID: <20070523223513.7dbb89f4@the-village.bc.nu>
In-Reply-To: <4654AD91.1030808@pobox.com>
References: <4635510D.4060103@shaw.ca>
	<200705231349.56976.jbarnes@virtuousgeek.org>
	<alpine.LFD.0.98.0705231352450.3890@woody.linux-foundation.org>
	<200705231403.24439.jbarnes@virtuousgeek.org>
	<4654AD91.1030808@pobox.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> One of the reasons why hardware vendors want to move away from 
> traditional accesses is to be able to use the larger config space in 
> PCI-Express, rather than being locked into the 256-byte legacy PCI 
> config space.

Mostly for treacherous computing extensions where subsets of the config
space can only be accessed by signed machines blessed by your favourite
movie company and video card vendor...

> Expect that to change, as MS shakes out the bugs (or maybe we are doing 
> their job for them?).

The longer it takes - the better.

Alan
