Return-Path: <linux-kernel-owner+w=401wt.eu-S1753293AbZI0DTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbZI0DTv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 23:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZI0DTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 23:19:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60903
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752223AbZI0DTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 23:19:48 -0400
Date: Sat, 26 Sep 2009 20:20:07 -0700 (PDT)
Message-Id: <20090926.202007.257820623.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       JBeulich@novell.com, akpm@linux-foundation.org
Subject: Re: linux-next: manual merge of the sparc-current tree with Linus'
 tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090926110158.0fcd2763.sfr@canb.auug.org.au>
References: <20090926110158.0fcd2763.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Sat, 26 Sep 2009 11:01:58 +1000

> Today's linux-next merge of the sparc-current tree got a conflict in
> arch/sparc/include/asm/vio.h between commit
> 8c87df457cb58fe75b9b893007917cf8095660a0 ("BUILD_BUG_ON(): fix it and a
> couple of bogus uses of it") from Linus' tree and commit
> 87ba00515657eede6077fa195ca6592b98cc31e3 ("sparc64: vio: Kill BUILD_BUG_ON
> () in vio_dring_avail()") from the sparc-current tree.
> 
> I just used the sparc-current version for today.

Thanks Stephen.  When Linus pulled in my tree he resolved the
merge conflict and thus you shouldn't have to deal with this
any more either.
