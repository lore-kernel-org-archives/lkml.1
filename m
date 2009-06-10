Return-Path: <linux-kernel-owner+w=401wt.eu-S1759449AbZFJMoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449AbZFJMoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 08:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755824AbZFJMoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 08:44:24 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:59752 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756840AbZFJMoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 08:44:23 -0400
From: Jeremy Kerr <jk@ozlabs.org>
To: patchwork@ozlabs.org
Subject: Re: [PATCH 3/5] can: af_can.c use rcu_barrier() on module unload.
Date: Wed, 10 Jun 2009 22:41:47 +1000
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: David Miller <davem@davemloft.net>, oliver@hartkopp.net,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
References: <4A2D112A.4000308@hartkopp.net> <4A2F6D32.8030400@hartkopp.net> <20090610.015245.141342130.davem@davemloft.net>
In-Reply-To: <20090610.015245.141342130.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906102241.47823.jk@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

> We really can't expect patchwork to look for every conceivable
> malignment of the various reviewer tags.

No, but we could probably be more tolerant about capitalisation. Any 
objections about ignoring case completely? I have a patch ready to 
push...

Cheers,


Jeremy
