Return-Path: <linux-kernel-owner+w=401wt.eu-S1031136AbXEAIgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031136AbXEAIgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 04:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711AbXEAIgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 04:36:16 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46233 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754698AbXEAIgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 04:36:14 -0400
Date: Tue, 1 May 2007 01:35:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?UTF-8?B?UmFmYcWC?= Bilski <rafalbilski@interia.pl>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Mark Brown <broonie@sirena.org.uk>
Subject: Re: Natsemi DP83815 driver spaming
Message-Id: <20070501013557.75f5c582.akpm@linux-foundation.org>
In-Reply-To: <4636F90A.2070303@interia.pl>
References: <46365887.3010705@interia.pl>
	<20070430205522.abad2481.akpm@linux-foundation.org>
	<4636E970.3010602@interia.pl>
	<4636F90A.2070303@interia.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 May 2007 10:23:38 +0200 Rafał Bilski <rafalbilski@interia.pl> wrote:

> Hello again,
> 
> I have downloaded DP83815 datasheet and I see that
> > eth0: Wake-up event 0x200000a
> means "broadcast received" and wakup on broadcast and 
> unicast enabled.
> > eth0: Wake-up event 0x80000a
> Above means "unicast received" and wakup on broadcast 
> and unicast enabled.
> I will try to check if disabling wakeup makes any difference.
> 

Thanks.

You've removed all the cc's I added.  I put them back.  Please always do
reply-to-all.


