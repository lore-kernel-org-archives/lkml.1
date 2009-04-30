Return-Path: <linux-kernel-owner+w=401wt.eu-S1757021AbZD3AZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021AbZD3AZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 20:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753808AbZD3AZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 20:25:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45286
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753090AbZD3AZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 20:25:38 -0400
Date: Wed, 29 Apr 2009 17:25:31 -0700 (PDT)
Message-Id: <20090429.172531.38936655.davem@davemloft.net>
To: hugh@veritas.com
Cc: akpm@linux-foundation.org, mel@csn.ul.ie, andi@firstfloor.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH mmotm] mm: alloc_large_system_hash check order
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0904292151350.30874@blonde.anvils>
References: <Pine.LNX.4.64.0904292151350.30874@blonde.anvils>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hugh@veritas.com>
Date: Wed, 29 Apr 2009 22:09:48 +0100 (BST)

> Cc'ed DaveM and netdev, just in case they're surprised it was asking for
> so much, or disappointed it's not getting as much as it was asking for.

This is basically what should be happening, thanks for the note.
