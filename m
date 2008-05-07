Return-Path: <linux-kernel-owner+w=401wt.eu-S934145AbYEGWiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934145AbYEGWiB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 18:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764898AbYEGWhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 18:37:42 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:36790
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934015AbYEGWhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 18:37:40 -0400
Date: Thu, 8 May 2008 00:37:38 +0200
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
Message-ID: <20080507223738.GF8276@duo.random>
References: <patchbomb.1210170950@duo.random> <e20917dcc8284b6a07cf.1210170951@duo.random> <20080507130528.adfd154c.akpm@linux-foundation.org> <alpine.LFD.1.10.0805071324570.3024@woody.linux-foundation.org> <20080507215840.GB8276@duo.random> <alpine.LFD.1.10.0805071509270.3024@woody.linux-foundation.org> <20080507222758.GD8276@duo.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080507222758.GD8276@duo.random>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 12:27:58AM +0200, Andrea Arcangeli wrote:
> I rechecked and I guarantee that the patches where Christoph isn't
> listed are developed by myself and he didn't write a single line on
> them. In any case I expect Christoph to review (he's CCed) and to
> point me to any attribution error. The only mistake I did once in that
> area was to give too _few_ attribution to myself and he asked me to
> add myself in the signed-off so I added myself by Christoph own
> request, but be sure I didn't remove him!

By PM (guess he's scared to post to this thread ;) Chris is telling
me, what you mean perhaps is I should add a From: Christoph in the
body of the email if the first signed-off-by is from Christoph, to
indicate the first signoff was by him and the patch in turn was
started by him. I thought the order of the signoffs was enough, but if
that From was mandatory and missing, if there's any error it obviously
wasn't intentional especially given I only left a signed-off-by:
christoph on his patches until he asked me to add my signoff
too. Correcting it is trivial given I carefully ordered the signoff so
that the author is at the top of the signoff list.

At least for mmu-notifier-core given I obviously am the original
author of that code, I hope the From: of the email was enough even if
an additional From: andrea was missing in the body.

Also you can be sure that Christoph and especially Robin (XPMEM) will
be more than happy if all patches with Christoph at the top of the
signed-off-by will be merged in 2.6.26 despite there wasn't From:
christoph at the top of the body ;). So I don't see a big deal here...
