Return-Path: <linux-kernel-owner+w=401wt.eu-S1755474AbZEZJ2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbZEZJ2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 05:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754406AbZEZJ2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 05:28:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35774
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754464AbZEZJ2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 05:28:11 -0400
Date: Tue, 26 May 2009 02:28:11 -0700 (PDT)
Message-Id: <20090526.022811.124842735.davem@davemloft.net>
To: vapier@gentoo.org
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 0/7] Blackfin fixes for 2.6.30
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090526.022659.11431807.davem@davemloft.net>
References: <1243329356-12644-1-git-send-email-vapier@gentoo.org>
	<20090526.022659.11431807.davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Tue, 26 May 2009 02:26:59 -0700 (PDT)

> 1) 10 patches is way too much this late in the 2.6.30 release process.
> 
>    Pick 1 or 2 that are the most critical and submit those for 2.6.30,
>    the rest get queued up for 2.6.31
> 
> 2) Networking patches must have netdev@vger.kernel.org at least
>    CC:'d so that your patches get properly traced at:
> 
>    http://patchwork.ozlabs.org/project/netdev/list/

I take back #1 I see what you're doing.

Please submit the one bfin_mac network driver patch via the proper
channels, that would be netdev@vger.kernel.org as mentioned, so I can
queue it up.

Thanks.
