Return-Path: <linux-kernel-owner+w=401wt.eu-S1751775AbYLCNYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775AbYLCNYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 08:24:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751078AbYLCNY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 08:24:26 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58683
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750951AbYLCNYY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 08:24:24 -0500
Date: Wed, 03 Dec 2008 00:36:36 -0800 (PST)
Message-Id: <20081203.003636.114008977.davem@davemloft.net>
To: dada1@cosmosbay.com
Cc: mchan@broadcom.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [BUG] linux-2.6.28-rc3 regression: IRQ smp_affinities not
 respected
From: David Miller <davem@davemloft.net>
In-Reply-To: <4934D000.5000304@cosmosbay.com>
References: <1227719692.13189.7.camel@HP1>
	<1228173819.15505.15.camel@HP1>
	<4934D000.5000304@cosmosbay.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <dada1@cosmosbay.com>
Date: Tue, 02 Dec 2008 07:04:48 +0100

> Michael Chan a écrit :
> > [PATCH] bnx2: Add workaround to handle missed MSI.
 ...
> Thanks a lot Michael
> 
> I tested your patch on my machine.
> 
> I confirm CPU unplug/hotplug works now (If correcting a bug in oprofile first)
> NIC doesnt freeze anymore

Applied to net-2.6, thanks everyone.
