Return-Path: <linux-kernel-owner+w=401wt.eu-S1763946AbXFRKNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763946AbXFRKNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 06:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762519AbXFRKKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 06:10:42 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:40795 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763525AbXFRKKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 06:10:40 -0400
Date: Mon, 18 Jun 2007 19:09:09 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: clameter@sgi.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       suresh.b.siddha@intel.com
Subject: Re: [patch 04/26] Slab allocators: Support __GFP_ZERO in all allocators.
Message-ID: <20070618100909.GB19056@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>, clameter@sgi.com,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Pekka Enberg <penberg@cs.helsinki.fi>,
	suresh.b.siddha@intel.com
References: <20070618095838.238615343@sgi.com> <20070618095914.332369986@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618095914.332369986@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 02:58:42AM -0700, clameter@sgi.com wrote:
> So add the necessary logic to all slab allocators to support __GFP_ZERO.
> 
Does this mean I should update my SLOB NUMA support patch? ;-)
