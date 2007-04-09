Return-Path: <linux-kernel-owner+w=401wt.eu-S932212AbXDISxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212AbXDISxK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 14:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932227AbXDISxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 14:53:10 -0400
Received: from ns2.suse.de ([195.135.220.15]:53829 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932212AbXDISxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 14:53:09 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [QUICKLIST 3/4] Quicklist support for x86_64
Date: Mon, 9 Apr 2007 20:53:05 +0200
User-Agent: KMail/1.9.6
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
References: <20070409182509.8559.33823.sendpatchset@schroedinger.engr.sgi.com> <200704092049.34317.ak@suse.de> <Pine.LNX.4.64.0704091150260.8783@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0704091150260.8783@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704092053.05590.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 April 2007 20:51:00 Christoph Lameter wrote:
> On Mon, 9 Apr 2007, Andi Kleen wrote:
> 
> > > It has to be done in sync with tlb flushing.
> > 
> > Why?
> 
> Otherwise you will leak pages to the page allocator before the tlb flush 
> occurred.

I don't get it sorry. Can you please explain in more detail?

-Andi


