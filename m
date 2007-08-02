Return-Path: <linux-kernel-owner+w=401wt.eu-S1757353AbXHBNAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353AbXHBNAe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 09:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363AbXHBNA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 09:00:27 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57239 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754841AbXHBNA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 09:00:26 -0400
Date: Thu, 2 Aug 2007 14:06:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Knut Petersen <Knut_Petersen@t-online.de>, trenn@suse.de,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       pavel@ucw.cz, mjg59@srcf.ucam.org, lenb@kernel.org,
       Adrian =?UTF-8?B?U2NocsO2dGVy?= <adrian@suse.de>,
       "Zhang, Rui" <rui.zhang@intel.com>, Jean Delvare <khali@linux-fr.org>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: 2.6.22 regression: thermal trip points
Message-ID: <20070802140639.2665c556@the-village.bc.nu>
In-Reply-To: <20070802120613.GB440@one.firstfloor.org>
References: <46B1988C.3090302@t-online.de>
	<1186047747.18821.450.camel@queen.suse.de>
	<46B1C0BA.1020004@t-online.de>
	<20070802120613.GB440@one.firstfloor.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Andi, would the above be mechanism sufficiently safe for your taste?
> 
> No.

I don't beleve Andi's taste (or lack thereof) is relevant to this
discussion. He's not for example explained why its better to force people
to disable all the APCI power and thermal control on their system rather
than adjust trip points.

