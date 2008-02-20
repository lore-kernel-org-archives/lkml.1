Return-Path: <linux-kernel-owner+w=401wt.eu-S1753627AbYBTIOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbYBTIOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 03:14:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbYBTIOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 03:14:16 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56490
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752381AbYBTION (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 03:14:13 -0500
Date: Wed, 20 Feb 2008 00:14:50 -0800 (PST)
Message-Id: <20080220.001450.132579707.davem@davemloft.net>
To: dada1@cosmosbay.com
Cc: yanmin_zhang@linux.intel.com, Valdis.Kletnieks@vt.edu,
       herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: tbench regression in 2.6.25-rc1
From: David Miller <davem@davemloft.net>
In-Reply-To: <47BBD8E9.2090700@cosmosbay.com>
References: <47BA87F0.1050709@cosmosbay.com>
	<1203491081.3248.60.camel@ymzhang>
	<47BBD8E9.2090700@cosmosbay.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <dada1@cosmosbay.com>
Date: Wed, 20 Feb 2008 08:38:17 +0100

> Thanks very much Yanmin, I think we can apply your patch as is, if no 
> regression was found for 32bits.

Great.  Can I get a resubmission of the patch with a cleaned up
changelog entry that describes in the regression along with the
changelog bits I saw in the most recent version of the patch?

An explicit "Acked-by:" from Eric would be nice too :-)

Thanks!
