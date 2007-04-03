Return-Path: <linux-kernel-owner+w=401wt.eu-S1751498AbXDCDUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498AbXDCDUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 23:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbXDCDUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 23:20:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47461
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751328AbXDCDUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 23:20:16 -0400
Date: Mon, 02 Apr 2007 20:20:14 -0700 (PDT)
Message-Id: <20070402.202014.11599182.davem@davemloft.net>
To: dhowells@redhat.com
Cc: torvalds@osdl.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/9] AF_RXRPC: Move generic skbuff stuff from XFRM code
 to generic code
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070402224503.31568.1112.stgit@warthog.cambridge.redhat.com>
References: <20070402224449.31568.17833.stgit@warthog.cambridge.redhat.com>
	<20070402224503.31568.1112.stgit@warthog.cambridge.redhat.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Mon, 02 Apr 2007 23:45:03 +0100

> Move generic skbuff stuff from XFRM code to generic code so that AF_RXRPC can
> use it too.
> 
> The kdoc comments I've attached to the functions needs to be checked by whoever
> wrote them as I had to make some guesses about the workings of these functions.
> 
> Signed-Off-By: David Howells <dhowells@redhat.com>

Patch applied to net-2.6.22, thanks a lot David.
