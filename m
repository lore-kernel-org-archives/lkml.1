Return-Path: <linux-kernel-owner+w=401wt.eu-S1762799AbYBZVe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762799AbYBZVe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:34:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762872AbYBZVet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:34:49 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49895
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1762396AbYBZVeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:34:46 -0500
Date: Tue, 26 Feb 2008 13:35:31 -0800 (PST)
Message-Id: <20080226.133531.69481052.davem@davemloft.net>
To: mingo@elte.hu
Cc: akpm@linux-foundation.org, dada1@cosmosbay.com,
       herbert@gondor.apana.org.au, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: include/linux/pcounter.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080226092454.GA10987@elte.hu>
References: <20080216112618.ec450f9b.akpm@linux-foundation.org>
	<20080216.215401.20463603.davem@davemloft.net>
	<20080226092454.GA10987@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 26 Feb 2008 10:24:54 +0100

> but the main and fundamental question still remains unanswered (more 
> than 3 weeks after Andrew asked that question): why was this piece of 
> general infrastructure merged via net.git and not submitted to lkml 
> ever? The code touching -mm does _not_ count as "review".

I already stated this was a mistake and it won't happen
again in the future.

And if you ask Andrew, he'll tell you I've been hard on
my network developers about this lately.
