Return-Path: <linux-kernel-owner+w=401wt.eu-S1757500AbZBSBtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500AbZBSBtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 20:49:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbZBSBsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 20:48:52 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41246
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751381AbZBSBsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 20:48:51 -0500
Date: Wed, 18 Feb 2009 17:48:35 -0800 (PST)
Message-Id: <20090218.174835.12982157.davem@davemloft.net>
To: divy@chelsio.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 2.6.30] cxgb3: Add support for PCI ID 0x35.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090216044615.24884.9331.stgit@speedy5>
References: <20090216044615.24884.9331.stgit@speedy5>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Sun, 15 Feb 2009 20:46:15 -0800

> Add support for adapters with a PCI id equal to 0x35.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

Adding new IDs is something we can do in net-2.6, so I'm
going to add this patch there.

Let me know if you don't want me to do that, or if there
is some dependency with net-next-2.6 that I'm not seeing.

Thanks!
