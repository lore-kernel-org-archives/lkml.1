Return-Path: <linux-kernel-owner+w=401wt.eu-S1759943AbXEIW5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759943AbXEIW5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 18:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759509AbXEIW5C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 18:57:02 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54128 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759392AbXEIW47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 18:56:59 -0400
Date: Wed, 9 May 2007 15:56:57 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Yu, Fenghua" <fenghua.yu@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Call percpu smp cacheline algin interface
In-Reply-To: <20070509155326.5e02f60d.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705091556260.1221@schroedinger.engr.sgi.com>
References: <20070509133328.c79ef48e.akpm@linux-foundation.org>
 <A29F7A5700A7EA4380E08C1F68C3B6D802B5F702@scsmsx411.amr.corp.intel.com>
 <20070509155326.5e02f60d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007, Andrew Morton wrote:

> erm, it's not obviosu from all this that the patches are worth proceeding
> with, are they?

What was it? 0.5% performance improvement on a synthetic benchmark? 
Process wakeup I believe?


