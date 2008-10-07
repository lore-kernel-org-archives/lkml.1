Return-Path: <linux-kernel-owner+w=401wt.eu-S1756974AbYJGVFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974AbYJGVFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 17:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbYJGVFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 17:05:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56939
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751951AbYJGVFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 17:05:33 -0400
Date: Tue, 07 Oct 2008 14:05:09 -0700 (PDT)
Message-Id: <20081007.140509.48442086.davem@davemloft.net>
To: npiggin@suse.de
Cc: dada1@cosmosbay.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org, paulmck@us.ibm.com
Subject: Re: [patch][rfc] ddds: "dynamic dynamic data structure" algorithm,
 for adaptive dcache hash table sizing (resend)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081007080656.GB16143@wotan.suse.de>
References: <20081007070225.GB5959@wotan.suse.de>
	<48EB11BB.2060704@cosmosbay.com>
	<20081007080656.GB16143@wotan.suse.de>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>
Date: Tue, 7 Oct 2008 10:06:56 +0200

> Hmm, that is interesting. What are the exact semantics of this rt_cache
> file?

It dumps the whole set of elements in the routing cache hash table.
