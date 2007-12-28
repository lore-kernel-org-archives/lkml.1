Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbXL1AU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbXL1AU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 19:20:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755284AbXL1ASZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 19:18:25 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37300
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755346AbXL1ASX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 19:18:23 -0500
Date: Thu, 27 Dec 2007 16:18:22 -0800 (PST)
Message-Id: <20071227.161822.262276105.davem@davemloft.net>
To: travis@sgi.com
Cc: akpm@linux-foundation.org, clameter@sgi.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/10] Sparc64: Use generic percpu
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071228001618.687461000@sgi.com>
References: <20071228001617.597161000@sgi.com>
	<20071228001618.687461000@sgi.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: travis@sgi.com
Date: Thu, 27 Dec 2007 16:16:25 -0800

> Sparc64 has a way of providing the base address for the per cpu area of the
> currently executing processor in a global register.
> 
> Sparc64 also provides a way to calculate the address of a per cpu area
> from a base address instead of performing an array lookup.
> 
> Cc: David Miller <davem@davemloft.net>
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> Signed-off-by: Mike Travis <travis@sgi.com>

Acked-by: David S. Miller <davem@davemloft.net>
