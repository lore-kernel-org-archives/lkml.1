Return-Path: <linux-kernel-owner+w=401wt.eu-S969617AbXILOeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969617AbXILOeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 10:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967753AbXILOd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 10:33:58 -0400
Received: from 74-93-104-98-Washington.hfc.comcastbusiness.net ([74.93.104.98]:57420
	"EHLO picasso.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S967691AbXILOd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 10:33:57 -0400
Date: Wed, 12 Sep 2007 07:33:44 -0700 (PDT)
Message-Id: <20070912.073344.27797445.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: hadi@cyberus.ca, lists@nerdbynature.de, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: 2.6.23-rc5: possible irq lock inversion dependency detected
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070911124327.GA6183@gondor.apana.org.au>
References: <20070911021812.GA1544@gondor.apana.org.au>
	<1189512106.4231.6.camel@localhost>
	<20070911124327.GA6183@gondor.apana.org.au>
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Tue, 11 Sep 2007 20:43:27 +0800

> On Tue, Sep 11, 2007 at 08:01:46AM -0400, jamal wrote:
> >
> > [NET_SCHED] protect action config/dump from irqs
> 
> Looks good! Thanks Jamal.

Applied, I'll try to push this in some time soon.
