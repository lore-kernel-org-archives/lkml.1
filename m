Return-Path: <linux-kernel-owner+w=401wt.eu-S1764508AbZEARUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764508AbZEARUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 13:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763073AbZEARUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 13:20:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59083
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754932AbZEARU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 13:20:28 -0400
Date: Fri, 01 May 2009 10:20:22 -0700 (PDT)
Message-Id: <20090501.102022.149412194.davem@davemloft.net>
To: hugh@veritas.com
Cc: akpm@linux-foundation.org, mel@csn.ul.ie, andi@firstfloor.org,
       anton@samba.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 2.6.30] Doc: hashdist defaults on for 64bit
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0905011442540.19247@blonde.anvils>
References: <20090429142825.6dcf233d.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0905011354560.19012@blonde.anvils>
	<Pine.LNX.4.64.0905011442540.19247@blonde.anvils>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hugh@veritas.com>
Date: Fri, 1 May 2009 14:45:43 +0100 (BST)

> Update Doc: kernel boot parameter hashdist now defaults on for all 64bit NUMA.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>

Acked-by: David S. Miller <davem@davemloft.net>
