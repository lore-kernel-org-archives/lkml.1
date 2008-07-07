Return-Path: <linux-kernel-owner+w=401wt.eu-S1758139AbYGGS7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139AbYGGS7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 14:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757851AbYGGS6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 14:58:25 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58502 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757816AbYGGS6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 14:58:23 -0400
Message-ID: <48726734.7080601@garzik.org>
Date: Mon, 07 Jul 2008 14:57:56 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: David Woodhouse <dwmw2@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       David Miller <davem@davemloft.net>, tytso@mit.edu, hugh@veritas.com,
       akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       mchan@broadcom.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
References: <1215093175.10393.567.camel@pmac.infradead.org>	<20080703173040.GB30506@mit.edu>	<1215111362.10393.651.camel@pmac.infradead.org>	<20080703.162120.206258339.davem@davemloft.net>	<486D6DDB.4010205@infradead.org>	<87ej6armez.fsf@basil.nowhere.org>	<1215177044.10393.743.camel@pmac.infradead.org>	<486E2260.5050503@garzik.org>	<1215178035.10393.763.camel@pmac.infradead.org>	<486E2818.1060003@garzik.org>	<1215179161.10393.773.camel@pmac.infradead.org>	<486E2E9B.20200@garzik.org>	<20080704153822.4db2f325@lxorguk.ukuu.org.uk>	<48715807.8070605@garzik.org>	<20080707165333.6347f564@the-village.bc.nu>	<48725155.2040007@garzik.org> <20080707191359.11f6297f@the-village.bc.nu>
In-Reply-To: <20080707191359.11f6297f@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> When the firmware travels with the module, as it does today in tg3, bnx2 
>> and others, is the most reliable system available.  The simplest, the 
>> least amount of "parts", the easiest to upgrade, the best method to 
>> guarantee driver/firmware version matches.  It works wonderfully today.
>>
>> Is it difficult to see why someone might want to keep the same attributes?
> 
> No I can see that, should be a simple matter of sending David patches.

Isn't it David's obligation not to remove a highly reliable, working system?

	Jeff



