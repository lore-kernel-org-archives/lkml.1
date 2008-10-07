Return-Path: <linux-kernel-owner+w=401wt.eu-S1756502AbYJGVNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502AbYJGVNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 17:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbYJGVNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 17:13:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53851
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753264AbYJGVNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 17:13:21 -0400
Date: Tue, 07 Oct 2008 14:12:57 -0700 (PDT)
Message-Id: <20081007.141257.167511509.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org, trond.myklebust@fys.uio.no, dlezcano@fr.ibm.com,
       penberg@cs.helsinki.fi, neilb@suse.de
Subject: Re: [PATCH 03/32] net: ipv6: clean up ip6_route_net_init() error
 handling
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081002131607.731557157@chello.nl>
References: <20081002130504.927878499@chello.nl>
	<20081002131607.731557157@chello.nl>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu, 02 Oct 2008 15:05:07 +0200

> ip6_route_net_init() error handling looked less than solid, fix 'er up.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Looks good, applied to net-next-2.6
