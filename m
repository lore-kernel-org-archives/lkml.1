Return-Path: <linux-kernel-owner+w=401wt.eu-S1761065AbZCZWZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761065AbZCZWZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 18:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756937AbZCZWZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 18:25:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42541
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755456AbZCZWZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 18:25:28 -0400
Date: Thu, 26 Mar 2009 15:25:15 -0700 (PDT)
Message-Id: <20090326.152515.43533230.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking for 2.6.30
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090326.020714.36421849.davem@davemloft.net>
References: <20090326.020714.36421849.davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Thu, 26 Mar 2009 02:07:14 -0700 (PDT)

> 
> These are the networking updates for 2.6.30
> 
> The safest fix for the GRO stinker Ingo and others ran into
> is here as well, and I will push that to -stable once it
> hits your tree.

Just FYI, I've just pushed a merge of the changes you pulled in today
in order to resolve the one merge conflict that arose.

> Please pull, thanks a lot!
> 
> The following changes since commit 8e0ee43bc2c3e19db56a4adaa9a9b04ce885cd84:
>   Linus Torvalds (1):
>         Linux 2.6.29
> 
> are available in the git repository at:
> 
>   master.kernel.org:/pub/scm/linux/kernel/git/davem/net-next-2.6.git master

Thanks!
