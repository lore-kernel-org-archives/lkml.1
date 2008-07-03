Return-Path: <linux-kernel-owner+w=401wt.eu-S1754421AbYGCMDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbYGCMDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756794AbYGCMCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:02:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34724 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756773AbYGCMCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:02:46 -0400
Message-ID: <486CA1D4.8050108@firstfloor.org>
Date: Thu, 03 Jul 2008 11:54:28 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Andrew Morton <akpm@linux-foundation.org>, vda.linux@googlemail.com,
       linux-arch@vger.kernel.org, rmk@arm.linux.org.uk, dhowells@redhat.com,
       ralf@linux-mips.org, kernel@wantstofly.org, jwboyer@linux.vnet.ibm.com,
       paulus@samba.org, dwmw2@infradead.org, torvalds@linux-foundation.org,
       paul.gortmaker@windriver.com, linux-embedded@vger.kernel.org,
       linux-kernel@vger.kernel.org, tim.bird@am.sony.com,
       schwidefsky@de.ibm.com, davem@davemloft.net
Subject: Re: [PATCH 21/23] make section names compatible with -ffunction-sections
 -fdata-sections: v850
References: <200807020242.21960.vda.linux@googlemail.com> <20080702145859.a9af30ea.akpm@linux-foundation.org> <486BFC21.1040001@firstfloor.org> <200807030017.53747.arnd@arndb.de>
In-Reply-To: <200807030017.53747.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Thursday 03 July 2008, Andi Kleen wrote:
>> Same seems to be true for cris btw.
> 
> Cris has seen significant updates in 2.6.25 by its maintainer.

Hmm missed that, sorry. It was just last time I looked cris
didn't seem to have any updates for a long time.

> It's not a very active port, but skipping updates for one kernel
> version 

It was far longer than that.

-Andi
