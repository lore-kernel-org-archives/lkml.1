Return-Path: <linux-kernel-owner+w=401wt.eu-S935203AbZAOXyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935203AbZAOXyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 18:54:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756871AbZAOXyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 18:54:35 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44446
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753787AbZAOXyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 18:54:33 -0500
Date: Thu, 15 Jan 2009 15:54:34 -0800 (PST)
Message-Id: <20090115.155434.206643894.davem@davemloft.net>
To: w@1wt.eu
Cc: herbert@gondor.apana.org.au, jarkao2@gmail.com, zbr@ioremap.net,
       dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH] tcp: splice as many packets as possible at once
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090115234408.GA1693@1wt.eu>
References: <20090115.153449.204259387.davem@davemloft.net>
	<20090115234255.GE1123@1wt.eu>
	<20090115234408.GA1693@1wt.eu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>
Date: Fri, 16 Jan 2009 00:44:08 +0100

> And BTW feel free to add my Tested-by if you want in case you merge
> this fix.

Done, thanks Willy.
