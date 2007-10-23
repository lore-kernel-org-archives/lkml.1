Return-Path: <linux-kernel-owner+w=401wt.eu-S1754392AbXJWVfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbXJWVfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 17:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbXJWVf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 17:35:28 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59128 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751862AbXJWVf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 17:35:27 -0400
Date: Tue, 23 Oct 2007 22:38:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Jones <davej@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>, "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Adam Jackson <ajax@redhat.com>, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] Add eeprom_bad_csum_allow module option to e1000.
Message-ID: <20071023223804.2ee9755f@the-village.bc.nu>
In-Reply-To: <20071023212026.GF7793@redhat.com>
References: <11931515302013-git-send-email-ajax@redhat.com>
	<471E1ECD.80002@intel.com>
	<1193156487.26974.39.camel@localhost.localdomain>
	<471E2AD0.1000500@intel.com>
	<471E5C21.8030908@garzik.org>
	<20071023212026.GF7793@redhat.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> People aren't going to report this as a bug. They aren't going to try out patches,
> they're going to do what I did and stick another network card in the box and
> go on with life.
> 
> Our users deserve better than this.

Agreed. By all means warn people, or give them a 1-800 Intel number to
phone, but they should be able to continue as well.

Alan
