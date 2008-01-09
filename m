Return-Path: <linux-kernel-owner+w=401wt.eu-S1753954AbYAIPVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbYAIPVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 10:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbYAIPVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 10:21:17 -0500
Received: from ns1.suse.de ([195.135.220.2]:39556 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbYAIPVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 10:21:17 -0500
Date: Wed, 9 Jan 2008 16:21:15 +0100
From: Andi Kleen <ak@suse.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Dave Airlie <airlied@linux.ie>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, hch@lst.de, ak@suse.de, pq@iki.fi,
       jbeulich@novell.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "x86: optimize page faults like all other
	achitectures and kill notifier cruft"
Message-ID: <20080109152115.GJ25945@bingen.suse.de>
References: <alpine.DEB.0.82.0801090226240.9570@skynet.skynet.ie> <20080108190611.3b9c0760.akpm@linux-foundation.org> <alpine.DEB.0.82.0801090308230.9570@skynet.skynet.ie> <20080109071846.5c672a5c@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109071846.5c672a5c@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 07:18:46AM -0800, Arjan van de Ven wrote:
> On Wed, 9 Jan 2008 03:17:37 +0000 (GMT)
> Dave Airlie <airlied@linux.ie> wrote:
> 
> > So all distros with 2.6.24 kernels are useless to mmiotrace I don't
> > see why leaving things as is until a suitable replacement mechanism
> > can be used.. 
> 
> you work for a distro.. surely you can convince your own distro to carry this patch for one release?
> Maybe if it's this important.. so can the others...

But if it's good for a major distribution why is it not good for mainline?

We had this discussion at last kernel summit and the answer was clear.

-Andi
