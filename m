Return-Path: <linux-kernel-owner+w=401wt.eu-S1753331AbYGYKzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbYGYKzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 06:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbYGYKzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 06:55:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60372
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751477AbYGYKzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 06:55:03 -0400
Date: Fri, 25 Jul 2008 03:55:01 -0700 (PDT)
Message-Id: <20080725.035501.47770769.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: pupilla@hotmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: ipsec: ipcomp - Decompress into frags if necessary
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080725104603.GA17974@gondor.apana.org.au>
References: <20080725074328.GB16747@gondor.apana.org.au>
	<20080725.025801.229691344.davem@davemloft.net>
	<20080725104603.GA17974@gondor.apana.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Fri, 25 Jul 2008 18:46:03 +0800

> On Fri, Jul 25, 2008 at 02:58:01AM -0700, David Miller wrote:
> > So perhaps it wants a WARN_ON :-)
> 
> There is one :)

Indeed, I even read that thing as I was composing my original
reply, hehe.
