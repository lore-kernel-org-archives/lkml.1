Return-Path: <linux-kernel-owner+w=401wt.eu-S1759345AbYB0T7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345AbYB0T7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 14:59:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757789AbYB0T7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 14:59:35 -0500
Received: from relay1.sgi.com ([192.48.171.29]:38124 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754234AbYB0T7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 14:59:34 -0500
Date: Wed, 27 Feb 2008 11:59:32 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, travis@sgi.com
Subject: Re: [PATCH] alloc_percpu() fails to allocate percpu data
In-Reply-To: <47BDBC23.10605@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0802271158100.1790@schroedinger.engr.sgi.com>
References: <47BDBC23.10605@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any decision made on what to do about this one? Mike or I can 
repost the per cpu allocator against mm? The fix by Eric could be used 
in the interim for 2.6.24?

