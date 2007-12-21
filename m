Return-Path: <linux-kernel-owner+w=401wt.eu-S1763014AbXLUDNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763014AbXLUDNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 22:13:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbXLUDM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 22:12:57 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37128
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753264AbXLUDM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 22:12:56 -0500
Date: Thu, 20 Dec 2007 19:12:55 -0800 (PST)
Message-Id: <20071220.191255.265293332.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: elendil@planet.nl, alan@lxorguk.ukuu.org.uk, apw@shadowen.org,
       joe@perches.com, lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, trivial@kernel.org, rdunlap@xenotime.net,
       jschopp@austin.ibm.com
Subject: Re: Trailing periods in kernel messages
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071220181532.f31cdcaa.akpm@linux-foundation.org>
References: <20071220210741.6dc3caf5@the-village.bc.nu>
	<200712210243.35240.elendil@planet.nl>
	<20071220181532.f31cdcaa.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 20 Dec 2007 18:15:32 -0800

> No-period is a kernel idiom, produces perfectly readable output, I have
> never ever heard of anyone expressing the least concern over a lack of dots
> at the end of their printks and 91% of kernel code agrees.

I have never heard of a compiler expressing the least concern over
whitespace and other aspects of coding style.
