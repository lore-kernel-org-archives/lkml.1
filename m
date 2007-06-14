Return-Path: <linux-kernel-owner+w=401wt.eu-S1754493AbXFND41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbXFND41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 23:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbXFND4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 23:56:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59979
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752544AbXFND4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 23:56:17 -0400
Date: Wed, 13 Jun 2007 20:56:34 -0700 (PDT)
Message-Id: <20070613.205634.45179442.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: kaber@trash.net, oliver@neukum.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: cannot set IP for ethernet
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070614035341.GA21010@gondor.apana.org.au>
References: <200706121441.13561.oliver@neukum.org>
	<466EA861.2070509@trash.net>
	<20070614035341.GA21010@gondor.apana.org.au>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Thu, 14 Jun 2007 13:53:41 +1000

> Actually in his case it's because 2.6.22-rc4-git2 doesn't have the
> following changeset.

It's on the way, it just hasn't been picked up yet.
