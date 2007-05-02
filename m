Return-Path: <linux-kernel-owner+w=401wt.eu-S1766796AbXEBRDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766796AbXEBRDx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 13:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766802AbXEBRDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 13:03:53 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43273 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1766796AbXEBRDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 13:03:52 -0400
Date: Wed, 2 May 2007 10:03:50 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: 2.6.22 -mm merge plans: slub
In-Reply-To: <Pine.LNX.4.64.0705021346170.16517@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0705021002040.32271@schroedinger.engr.sgi.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705011846590.10660@blonde.wat.veritas.com>
 <20070501125559.9ab42896.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705012101410.26170@blonde.wat.veritas.com>
 <20070501133618.93793687.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705021346170.16517@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007, Hugh Dickins wrote:

> But if Linus' tree is to be better than a warehouse to avoid
> awkward merges, I still think we want it to default to on for
> all the architectures, and for most if not all -rcs.

At some point I dream that SLUB could become the default but I thought 
this would take at least 6 month or so. If want to force this now then I 
will certainly have some busy weeks ahead.

