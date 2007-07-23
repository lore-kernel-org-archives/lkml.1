Return-Path: <linux-kernel-owner+w=401wt.eu-S933882AbXGWTaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933882AbXGWTaj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 15:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761329AbXGWTa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 15:30:29 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56346 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761360AbXGWTa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 15:30:28 -0400
Date: Mon, 23 Jul 2007 12:30:25 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Greg KH <greg@kroah.com>, rientjes@google.com,
       Christoph Hellwig <hch@infradead.org>,
       David Miller <davem@davemloft.net>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: [PATCH 5/5] dma: use dev_to_node to get node for device in
 dma_alloc_pages
Message-ID: <20070723123025.708e14e2@schroedinger.engr.sgi.com>
In-Reply-To: <200707101653.09797.yinghai.lu@sun.com>
References: <200707101641.17672.yinghai.lu@sun.com>
	<200707101653.09797.yinghai.lu@sun.com>
Organization: Silicon Graphics, Inc.
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 16:53:09 -0700
Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> [PATCH 5/5] dma: use dev_to_node to get node for device in
> dma_alloc_pages

Acked-by: Christoph Lameter <clameter@sgi.com>
