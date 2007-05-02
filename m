Return-Path: <linux-kernel-owner+w=401wt.eu-S1767044AbXEBV2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767044AbXEBV2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 17:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767030AbXEBV2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 17:28:06 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59981 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766800AbXEBV2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 17:28:04 -0400
Date: Wed, 2 May 2007 14:27:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slub: remove duplicate VM_BUG_ON
Message-Id: <20070502142756.de29ab08.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705021413570.2469@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0705022307310.16215@sbz-30.cs.Helsinki.FI>
	<Pine.LNX.4.64.0705021311440.1978@schroedinger.engr.sgi.com>
	<4638F2DA.9080100@cs.helsinki.fi>
	<Pine.LNX.4.64.0705021413570.2469@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007 14:14:39 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Wed, 2 May 2007, Pekka Enberg wrote:
> 
> > Christoph Lameter wrote:
> > > Patch is already in mm. Could you download all the patches after that before
> > > testing? There was quite a number.
> > 
> > I am on 2.6.21-rc7-mm2. Me goes to wonder where Andrew's snapshots are...
> 
> Too much going on I think. I guess I saturated him with patches.
>  

yes, I'm very much in "slow things down, do it more carefully" mode.  I
have 350 patches sitting awaiting later consideration at present.

It's not so much that I'm personally swamped - it's more that I think we've
hit (exceeded) the rate at which we can feed stuff into the tree while
maintaining acceptable quality.

If others were to increase the amount of time they spend on testing,
reviewing and bugfixing it would help to level things out. 

I should have got the 2.6.22-mm-merge-plans email out a week or two
earlier, I'm afraid.  Things are looking somewhat messy.

