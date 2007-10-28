Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182AbXJ1NLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbXJ1NLi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 09:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751728AbXJ1NL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 09:11:29 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:45634 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbXJ1NL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 09:11:28 -0400
Date: Sun, 28 Oct 2007 15:11:26 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <clameter@sgi.com>
cc: Matthew Wilcox <matthew@wil.cx>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 05/10] SLUB: __slab_alloc() exit path consolidation
In-Reply-To: <20071028033259.504765424@sgi.com>
Message-ID: <Pine.LNX.4.64.0710281511090.6766@sbz-30.cs.Helsinki.FI>
References: <20071028033156.022983073@sgi.com> <20071028033259.504765424@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Oct 2007, Christoph Lameter wrote:
> Use a single exit path by using goto's to the hottest exit path.

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
