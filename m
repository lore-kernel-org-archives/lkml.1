Return-Path: <linux-kernel-owner+w=401wt.eu-S1753391AbZHBTap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbZHBTap (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 15:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbZHBTan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 15:30:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49066
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753392AbZHBTan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 15:30:43 -0400
Date: Sun, 02 Aug 2009 12:30:51 -0700 (PDT)
Message-Id: <20090802.123051.167883331.davem@davemloft.net>
To: divy@chelsio.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 2/2 net-next-2.6] cxgb3: fix Gen2 pci default settings
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090731072339.4325.23090.stgit@speedy5>
References: <20090731072334.4325.34323.stgit@speedy5>
	<20090731072339.4325.23090.stgit@speedy5>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Fri, 31 Jul 2009 00:23:39 -0700

> From: Divy Le Ray <divy@chelsio.com>
> 
> Modify control register settings to accommodate the bridge's max read requset
> size.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

Applied.
