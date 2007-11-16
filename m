Return-Path: <linux-kernel-owner+w=401wt.eu-S933174AbXKPCZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933174AbXKPCZK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 21:25:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758261AbXKPCY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 21:24:57 -0500
Received: from relay1.sgi.com ([192.48.171.29]:50807 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752232AbXKPCY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 21:24:57 -0500
Date: Thu, 15 Nov 2007 18:24:54 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, mel@csn.ul.ie,
       ak@suse.de, apw@shadowen.org
Subject: Re: x86_64: Make sparsemem/vmemmap the default memory model
In-Reply-To: <20071115141212.acb215f1.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0711151824310.31691@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711121549370.29178@schroedinger.engr.sgi.com>
 <200711130059.34346.ak@suse.de> <Pine.LNX.4.64.0711121615120.29328@schroedinger.engr.sgi.com>
 <200711130149.54852.ak@suse.de> <Pine.LNX.4.64.0711121940410.30269@schroedinger.engr.sgi.com>
 <20071115141212.acb215f1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007, Andrew Morton wrote:

> Unfortunately some loon has gone and merged the i386 and x86_64 Kconfig
> files.  I was fixing that up but I worry what effects these Kconfig changes
> might have on, for example, i386 NUMA setups.
> 
> So I'll duck this version, sorry.

Is there a tree that I can rediff the patch against?

