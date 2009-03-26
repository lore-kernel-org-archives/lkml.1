Return-Path: <linux-kernel-owner+w=401wt.eu-S1761665AbZCZXCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761665AbZCZXCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 19:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760278AbZCZXBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 19:01:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43466
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1761554AbZCZXBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 19:01:08 -0400
Date: Thu, 26 Mar 2009 16:00:55 -0700 (PDT)
Message-Id: <20090326.160055.187303434.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: rdreier@cisco.com, akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking for 2.6.30
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0903261555290.3032@localhost.localdomain>
References: <20090326.020714.36421849.davem@davemloft.net>
	<20090326.152515.43533230.davem@davemloft.net>
	<alpine.LFD.2.00.0903261555290.3032@localhost.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 26 Mar 2009 15:56:24 -0700 (PDT)

> On Thu, 26 Mar 2009, David Miller wrote:
> > 
> > Just FYI, I've just pushed a merge of the changes you pulled in today
> > in order to resolve the one merge conflict that arose.
> 
> Well, I merged infiniband, and that caused more conflicts. I fixed them 
> up, but people need to double-check my fixes.

Will do.
