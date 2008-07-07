Return-Path: <linux-kernel-owner+w=401wt.eu-S1754910AbYGGQ16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbYGGQ16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636AbYGGQ1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:27:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38576 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753358AbYGGQ1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:27:46 -0400
Date: Mon, 7 Jul 2008 16:53:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       David Miller <davem@davemloft.net>, tytso@mit.edu, hugh@veritas.com,
       akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       mchan@broadcom.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
Message-ID: <20080707165333.6347f564@the-village.bc.nu>
In-Reply-To: <48715807.8070605@garzik.org>
References: <1215093175.10393.567.camel@pmac.infradead.org>
	<20080703173040.GB30506@mit.edu>
	<1215111362.10393.651.camel@pmac.infradead.org>
	<20080703.162120.206258339.davem@davemloft.net>
	<486D6DDB.4010205@infradead.org>
	<87ej6armez.fsf@basil.nowhere.org>
	<1215177044.10393.743.camel@pmac.infradead.org>
	<486E2260.5050503@garzik.org>
	<1215178035.10393.763.camel@pmac.infradead.org>
	<486E2818.1060003@garzik.org>
	<1215179161.10393.773.camel@pmac.infradead.org>
	<486E2E9B.20200@garzik.org>
	<20080704153822.4db2f325@lxorguk.ukuu.org.uk>
	<48715807.8070605@garzik.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > And we had the same argument over ten years ago about those evil module
> > things which stopped you just using scp to copy the kernel in one go.
> > Fortunately the nay sayers lost so we have modules.
> 
> Broken analogy.
> 
> When modules were added, you were given the option to use them, or not.

You can still choose to compile firmware in. Did you read the patches ?
