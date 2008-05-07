Return-Path: <linux-kernel-owner+w=401wt.eu-S1762994AbYEGW3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762994AbYEGW3D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 18:29:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763715AbYEGW2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 18:28:05 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:48899
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763440AbYEGW2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 18:28:00 -0400
Date: Thu, 8 May 2008 00:27:58 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, clameter@sgi.com,
       steiner@sgi.com, holt@sgi.com, npiggin@suse.de, a.p.zijlstra@chello.nl,
       kvm-devel@lists.sourceforge.net, kanojsarcar@yahoo.com,
       rdreier@cisco.com, swise@opengridcomputing.com,
       linux-kernel@vger.kernel.org, avi@qumranet.com, linux-mm@kvack.org,
       general@lists.openfabrics.org, hugh@veritas.com, rusty@rustcorp.com.au,
       aliguori@us.ibm.com, chrisw@redhat.com, marcelo@kvack.org,
       dada1@cosmosbay.com, paulmck@us.ibm.com
Subject: Re: [PATCH 01 of 11] mmu-notifier-core
Message-ID: <20080507222758.GD8276@duo.random>
References: <patchbomb.1210170950@duo.random> <e20917dcc8284b6a07cf.1210170951@duo.random> <20080507130528.adfd154c.akpm@linux-foundation.org> <alpine.LFD.1.10.0805071324570.3024@woody.linux-foundation.org> <20080507215840.GB8276@duo.random> <alpine.LFD.1.10.0805071509270.3024@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805071509270.3024@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 03:11:10PM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 7 May 2008, Andrea Arcangeli wrote:
> 
> > > As far as I can tell, authorship has been destroyed by at least two of the 
> > > patches (ie Christoph seems to be the author, but Andrea seems to have 
> > > dropped that fact).
> > 
> > I can't follow this, please be more specific.
> 
> The patches were sent to lkml without *any* indication that you weren't 
> actually the author.
> 
> So if Andrew had merged them, they would have been merged as yours.

I rechecked and I guarantee that the patches where Christoph isn't
listed are developed by myself and he didn't write a single line on
them. In any case I expect Christoph to review (he's CCed) and to
point me to any attribution error. The only mistake I did once in that
area was to give too _few_ attribution to myself and he asked me to
add myself in the signed-off so I added myself by Christoph own
request, but be sure I didn't remove him!
