Return-Path: <linux-kernel-owner+w=401wt.eu-S934163AbYEGWju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934163AbYEGWju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 18:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760203AbYEGWjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 18:39:19 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:36822
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbYEGWjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 18:39:17 -0400
Date: Thu, 8 May 2008 00:39:14 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, npiggin@suse.de,
       chrisw@redhat.com, rusty@rustcorp.com.au, a.p.zijlstra@chello.nl,
       marcelo@kvack.org, kvm-devel@lists.sourceforge.net,
       kanojsarcar@yahoo.com, steiner@sgi.com, linux-kernel@vger.kernel.org,
       avi@qumranet.com, aliguori@us.ibm.com, paulmck@us.ibm.com,
       linux-mm@kvack.org, holt@sgi.com, general@lists.openfabrics.org,
       hugh@veritas.com, Andrew Morton <akpm@linux-foundation.org>,
       dada1@cosmosbay.com, clameter@sgi.com
Subject: Re: [ofa-general] Re: [PATCH 01 of 11] mmu-notifier-core
Message-ID: <20080507223914.GG8276@duo.random>
References: <patchbomb.1210170950@duo.random> <e20917dcc8284b6a07cf.1210170951@duo.random> <20080507130528.adfd154c.akpm@linux-foundation.org> <alpine.LFD.1.10.0805071324570.3024@woody.linux-foundation.org> <20080507215840.GB8276@duo.random> <alpine.LFD.1.10.0805071509270.3024@woody.linux-foundation.org> <20080507222758.GD8276@duo.random> <adaej8du4pf.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adaej8du4pf.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 03:31:08PM -0700, Roland Dreier wrote:
> I think the point you're missing is that any patches written by
> Christoph need a line like
> 
> From: Christoph Lameter <clameter@sgi.com>
> 
> at the top of the body so that Christoph becomes the author when it is
> committed into git.  The Signed-off-by: line needs to be preserved too
> of course, but it is not sufficient by itself.

Ok so I see the problem Linus is referring to now (I received the hint
by PM too), I thought the order of the signed-off-by was relevant, it
clearly isn't or we're wasting space ;)
