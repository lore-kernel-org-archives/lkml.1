Return-Path: <linux-kernel-owner+w=401wt.eu-S1762209AbXKNDsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762209AbXKNDsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 22:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756975AbXKNDs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 22:48:28 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39315
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757288AbXKNDs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 22:48:27 -0500
Date: Tue, 13 Nov 2007 19:48:26 -0800 (PST)
Message-Id: <20071113.194826.197093902.davem@davemloft.net>
To: andi@firstfloor.org
Cc: clameter@sgi.com, akpm@linux-foundation.org, linux-mm@vger.kernel.org,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       schwidefsky@de.ibm.com
Subject: Re: [patch 01/28] cpu alloc: The allocator
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071114022832.GC20365@one.firstfloor.org>
References: <p73wssly6sr.fsf@bingen.suse.de>
	<20071113.175208.168903694.davem@davemloft.net>
	<20071114022832.GC20365@one.firstfloor.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Wed, 14 Nov 2007 03:28:32 +0100

> ftp://firstfloor.org/pub/ak/x86_64/quilt/patches/early-reserve
> ftp://firstfloor.org/pub/ak/x86_64/quilt/patches/early-alloc 
> ftp://firstfloor.org/pub/ak/x86_64/quilt/patches/lockdep-early-alloc
> 
> I didn't plan to submit it for .24, just .25. Or do you need it 
> urgently?

I don't need it urgently, 2.6.25 is perfectly fine.

> Also it would require you to write a sparc specific arch_early_alloc()
> of course.  I've only done the x86-64 version.

I'll be sure to take care of that when it hits .25

Thanks Andi.
