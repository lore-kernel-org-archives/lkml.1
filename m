Return-Path: <linux-kernel-owner+w=401wt.eu-S1755527AbYLMB0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbYLMB0U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 20:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753282AbYLMB0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 20:26:10 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33042
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752865AbYLMB0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 20:26:09 -0500
Date: Fri, 12 Dec 2008 17:26:10 -0800 (PST)
Message-Id: <20081212.172610.193709492.davem@davemloft.net>
To: sam@ravnborg.org
Cc: akpm@linux-foundation.org, kkeil@suse.de, hannes@hanneseder.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 0/9] mISDN: fix sparse warnings
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081211210537.GA27010@uranus.ravnborg.org>
References: <20081210173056.GB15810@pingi.kke.suse.de>
	<20081211122245.754e7829.akpm@linux-foundation.org>
	<20081211210537.GA27010@uranus.ravnborg.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Thu, 11 Dec 2008 22:05:37 +0100

> Lately Davis Miller has included ISDN stuff in net-next.
> Try to fix the commented issues, add the acks you got, give patches
> proper titles and submit to netdev@vger.kernel.org

I actually have these in my queue, but I'm up in the
mountains snowboarding until Sunday so have only been
handling the most important fixes and easy patches.

Andrew, don't fret, I'll take care of these and they
won't get lost.

If it's cc:'d to netdev, there is next to zero chance
of the patch not getting either rejected or applied
since we track everything in patchwork.

You know, you too could look there for the state of
these misdn patches :-)

	http://patchwork.ozlabs.org/project/netdev/list/

Enjoy.
