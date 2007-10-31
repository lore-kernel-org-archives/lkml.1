Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946AbXJaEiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbXJaEiL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 00:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbXJaEhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 00:37:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46659
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751943AbXJaEhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 00:37:54 -0400
Date: Tue, 30 Oct 2007 21:37:53 -0700 (PDT)
Message-Id: <20071030.213753.126064697.davem@davemloft.net>
To: nickpiggin@yahoo.com.au
Cc: a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 00/33] Swap over NFS -v14
From: David Miller <davem@davemloft.net>
In-Reply-To: <200710311426.33223.nickpiggin@yahoo.com.au>
References: <20071030160401.296770000@chello.nl>
	<200710311426.33223.nickpiggin@yahoo.com.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <nickpiggin@yahoo.com.au>
Date: Wed, 31 Oct 2007 14:26:32 +1100

> Is it really worth all the added complexity of making swap
> over NFS files work, given that you could use a network block
> device instead?

Don't be misled.  Swapping over NFS is just a scarecrow for the
seemingly real impetus behind these changes which is network storage
stuff like iSCSI.
