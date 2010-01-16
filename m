Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab0APJoX (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 04:44:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517Ab0APJoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 04:44:18 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39437
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752732Ab0APJoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 04:44:15 -0500
Date: Sat, 16 Jan 2010 01:44:24 -0800 (PST)
Message-Id: <20100116.014424.168674434.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: steffen.klassert@secunet.com, tj@kernel.org, peterz@infradead.org,
        torvalds@linux-foundation.org, arjan@linux.intel.com,
        jens.axboe@oracle.com, andi@firstfloor.org, awalls@radix.net,
        linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
        akpm@linux-foundation.org, rusty@rustcorp.com.au,
        cl@linux-foundation.org, dhowells@redhat.com, avi@redhat.com,
        johannes@sipsolutions.net
Subject: Re: [PATCH 0/2] Parallel crypto/IPsec v7
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100107053903.GA2928@gondor.apana.org.au>
References: <20091223080000.GA32467@secunet.com>
	<20091223080152.GB32467@secunet.com>
	<20100107053903.GA2928@gondor.apana.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Thu, 7 Jan 2010 16:39:03 +1100

> On Wed, Dec 23, 2009 at 09:01:52AM +0100, Steffen Klassert wrote:
>> This patchset adds the 'pcrypt' parallel crypto template. With this template it
>> is possible to process the crypto requests of a transform in parallel without
>> getting request reorder. This is in particular interesting for IPsec.
> 
> All applied.  Thanks Steffen!

Steffen, thanks so much for sticking to this all the way to
the end.

