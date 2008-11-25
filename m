Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbYKYVwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbYKYVwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:52:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbYKYVwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:52:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38260
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750816AbYKYVwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:52:31 -0500
Date: Tue, 25 Nov 2008 13:52:31 -0800 (PST)
Message-Id: <20081125.135231.81163255.davem@davemloft.net>
To: mingo@elte.hu
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: fix error flow of crypto/testmgr.c:test_comp()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081125171438.GK22504@elte.hu>
References: <20081125085820.GA11401@elte.hu>
	<20081125152014.GB29096@gondor.apana.org.au>
	<20081125171438.GK22504@elte.hu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 25 Nov 2008 18:14:38 +0100

> btw, on a related note, there's a couple of networking related warning 
> fixes/annotations i've got queued up.

I see these now, but they would get properly logged and
tracked at:

	http://patchwork.ozlabs.org/project/netdev/

if you would simply CC: netdev instead of sending them into
the ether by informing lkml and the crypto list about them.
