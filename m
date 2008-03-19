Return-Path: <linux-kernel-owner+w=401wt.eu-S935292AbYCSWSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935292AbYCSWSw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115AbYCSUvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:51:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50249
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754924AbYCSUvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:51:49 -0400
Date: Wed, 19 Mar 2008 13:52:05 -0700 (PDT)
Message-Id: <20080319.135205.125229102.davem@davemloft.net>
To: benoit.boissinot@ens-lyon.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, pekkas@netcore.fi,
       yoshfuji@linux-ipv6.org
Subject: Re: [PATCH] [RFC] [IPv6] spelling fix in /proc:
 /proc/sys/net/ipv6/conf/default/temp_prefered_lft
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080319204227.GF6935@ens-lyon.fr>
References: <20080319204227.GF6935@ens-lyon.fr>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benoit Boissinot <benoit.boissinot@ens-lyon.org>
Date: Wed, 19 Mar 2008 21:42:27 +0100

> Is there a way to fix a bad spelling in /proc ?
> 
> Here is a patch to fix all the spelling error (prefered -> preferred)
> in the ipv6 code. I didn't change the /proc name but everything else is
> changed.
> Currently you can found both spelling in the ipv6 code.
> Is it ok ?

I think this doesn't add any value.

If the procfs file name has to remain the same, which it does,
changing variable and macro names to be different will only
cause merge conflicts and pain yet have no redeeming value.
