Return-Path: <linux-kernel-owner+w=401wt.eu-S1759915AbXISQPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759915AbXISQPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 12:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754720AbXISQP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 12:15:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39165
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754930AbXISQPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 12:15:25 -0400
Date: Wed, 19 Sep 2007 09:15:10 -0700 (PDT)
Message-Id: <20070919.091510.00787167.davem@davemloft.net>
To: drepper@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: follow-up: discrepancy with POSIX
From: David Miller <davem@davemloft.net>
In-Reply-To: <46F13E8B.4050309@redhat.com>
References: <46F13E8B.4050309@redhat.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulrich Drepper <drepper@redhat.com>
Date: Wed, 19 Sep 2007 08:21:47 -0700

> If you think the POSIX spec is wrong (and can point to other
> implementations doing the same as Linux) let me know and I'll work on
> getting the spec changed.

The whole AF_UNSPEC thing I'm almost certain comes from BSD, which has
behaved that way for centuries.

Someone needs to cull through Steven's Volume 2 to verify this, I'm
too busy at the moment to do so myself.
