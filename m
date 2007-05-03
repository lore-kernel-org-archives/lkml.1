Return-Path: <linux-kernel-owner+w=401wt.eu-S1161800AbXECK3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161800AbXECK3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 06:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161803AbXECK27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 06:28:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45943
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1161800AbXECK25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 06:28:57 -0400
Date: Thu, 03 May 2007 03:28:58 -0700 (PDT)
Message-Id: <20070503.032858.43414640.davem@davemloft.net>
To: dhowells@redhat.com
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org, kaber@trash.net
Subject: Re: [PATCH 4/5] [AFS]: Replace rtnetlink client by direct dev_base
 walking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070503095331.26912.18484.stgit@warthog.cambridge.redhat.com>
References: <20070503095315.26912.24270.stgit@warthog.cambridge.redhat.com>
	<20070503095331.26912.18484.stgit@warthog.cambridge.redhat.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Thu, 03 May 2007 10:53:31 +0100

> Replace the large and complicated rtnetlink client by two simple
> functions for getting the MAC address for the first ethernet device
> and building a list of IPv4 addresses.
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>
> Signed-off-by: David Howells <dhowells@redhat.com>

Applied.
