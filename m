Return-Path: <linux-kernel-owner+w=401wt.eu-S2993034AbXDYUCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993034AbXDYUCQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 16:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993028AbXDYUCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 16:02:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48116
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S2993020AbXDYUCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 16:02:14 -0400
Date: Wed, 25 Apr 2007 13:02:21 -0700 (PDT)
Message-Id: <20070425.130221.102574755.davem@davemloft.net>
To: dhowells@redhat.com
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 00/16] AF_RXRPC socket family and AFS rewrite [try #3] 
From: David Miller <davem@davemloft.net>
In-Reply-To: <32075.1177531007@redhat.com>
References: <20070425105036.10872.48596.stgit@warthog.cambridge.redhat.com>
	<13484.1177508312@redhat.com>
	<32075.1177531007@redhat.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Wed, 25 Apr 2007 20:56:47 +0100

> David Miller <davem@davemloft.net> wrote:
> 
> > Then please generate your patches against my net-2.6.21 GIT
> > tree.  Most of your initial patches in the series (the SKB
> > routine one for example) are already in my tree.
> 
> Do you mean your net-2.6.22 GIT tree?
> 
> Do you want me to make it available as a GIT tree for you to pull?  Or would
> you prefer patches?

Just patches is perfectly fine.

Also, if it's easier to diff against -mm, that works too
since Andrew integrates my net-2.6.22 tree into -mm most
of the time.
