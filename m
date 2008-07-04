Return-Path: <linux-kernel-owner+w=401wt.eu-S1759223AbYGDNqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759223AbYGDNqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 09:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758748AbYGDNq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 09:46:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41215 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757179AbYGDNq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 09:46:26 -0400
Date: Fri, 4 Jul 2008 14:27:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       David Miller <davem@davemloft.net>, tytso@mit.edu, hugh@veritas.com,
       akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       mchan@broadcom.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
Message-ID: <20080704142753.27848ff8@lxorguk.ukuu.org.uk>
In-Reply-To: <486E2818.1060003@garzik.org>
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
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why is it so difficult to see the value of KEEPING STUFF WORKING AS IT 
> WORKS TODAY?

Sure Jeff. Lets delete libata, that caused all sorts of problems when it
was being added. We could freeze on linux 1.2.13-lmp, that was a good
release - why break it ?

There are good sound reasons for having a firmware tree, the fact tg3 is
a bit of dinosaur in this area doesn't make it wrong.
