Return-Path: <linux-kernel-owner+w=401wt.eu-S1758385AbYBEAoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758385AbYBEAoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 19:44:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757463AbYBEAnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 19:43:52 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33461 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757352AbYBEAnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 19:43:51 -0500
Date: Mon, 4 Feb 2008 16:43:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: herbert@gondor.apana.org.au, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: include/linux/pcounter.h
Message-Id: <20080204164309.c5c721fb.akpm@linux-foundation.org>
In-Reply-To: <20080204.162035.74110396.davem@davemloft.net>
References: <20080204014402.1c55d3fe.akpm@linux-foundation.org>
	<20080204.162035.74110396.davem@davemloft.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Feb 2008 16:20:35 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Mon, 4 Feb 2008 01:44:02 -0800
> 
> > Please do not merge pieces of generic kernel infrastructure while
> > keeping it all secret on the netdev list.  Ever.
> 
> It was so damn secret that it sat in your -mm tree for months.

I never noticed it and I doubt if anyone else did.  How was I (or anyone
else) to have known?

> Don't be rediculious Andrew.

There is nothing ridiculous about requiring that new generic kernel
infrastructure patches be appropriately submitted and reviewed.

