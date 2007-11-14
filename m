Return-Path: <linux-kernel-owner+w=401wt.eu-S1758146AbXKNBsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146AbXKNBsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 20:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754111AbXKNBs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 20:48:29 -0500
Received: from relay1.sgi.com ([192.48.171.29]:33640 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751950AbXKNBs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 20:48:28 -0500
Date: Tue, 13 Nov 2007 17:48:27 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: akpm@linux-foundation.org, linux-mm@vger.kernel.org,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       schwidefsky@de.ibm.com
Subject: Re: [patch 01/28] cpu alloc: The allocator
In-Reply-To: <20071113.173009.247667472.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0711131748160.6539@schroedinger.engr.sgi.com>
References: <20071106195157.878563669@sgi.com> <20071113.031510.151440585.davem@davemloft.net>
 <Pine.LNX.4.64.0711131339240.3714@schroedinger.engr.sgi.com>
 <20071113.173009.247667472.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007, David Miller wrote:

> I'm surprised this is your reaction instead of "oh damn, sorry
> I bloated up the kernel image size by 8mb, I'll find a way to
> fix that."

Well I found a way to fix that and its in the patch...

