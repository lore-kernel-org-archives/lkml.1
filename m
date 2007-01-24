Return-Path: <linux-kernel-owner+w=401wt.eu-S1751886AbXAXO73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbXAXO73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 09:59:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbXAXO73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 09:59:29 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:40555 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751886AbXAXO72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 09:59:28 -0500
Date: Wed, 24 Jan 2007 06:58:42 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Aubrey Li <aubreylee@gmail.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Robin Getz <rgetz@blackfin.uclinux.org>,
       "Henn, erich, Michael" <Michael.Hennerich@analog.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Limit the size of the pagecache
In-Reply-To: <45B7561C.9000102@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0701240657130.9696@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0701231645260.5239@schroedinger.engr.sgi.com>
 <1169625333.4493.16.camel@taijtu> <45B7561C.9000102@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jan 2007, Nick Piggin wrote:

> I can't argue that a smaller pagecache will be subject to a
> higher turnaround given the same workload, but I don't know why
> that would be a good thing.

Neither do I. Wonder why we need this but I keep getting 
these requests. Could we either find a reason for limiting the pagecache 
or get this out of our system for good?
