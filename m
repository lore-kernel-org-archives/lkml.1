Return-Path: <linux-kernel-owner+w=401wt.eu-S1758073AbYJ3SDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073AbYJ3SDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 14:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755499AbYJ3SDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 14:03:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42870 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754536AbYJ3SDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 14:03:23 -0400
Date: Thu, 30 Oct 2008 16:04:43 -0200
From: Glauber Costa <glommer@redhat.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Nick Piggin <npiggin@suse.de>, Avi Kivity <avi@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       aliguori@codemonkey.ws, Jeremy Fitzhardinge <jeremy@goop.org>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>
Subject: Re: [PATCH] regression: vmalloc easily fail.
Message-ID: <20081030180443.GE18634@poweredge.glommer>
References: <1225234513-3996-1-git-send-email-glommer@redhat.com> <20081028232944.GA3759@wotan.suse.de> <20081029094856.GD4269@poweredge.glommer> <20081029101145.GB5953@wotan.suse.de> <49083B14.6070402@redhat.com> <20081029104333.GD5953@wotan.suse.de> <20081029220737.GF11532@poweredge.glommer> <20081030044941.GA9470@wotan.suse.de> <1225385162.23508.33.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225385162.23508.33.camel@calx>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 11:46:02AM -0500, Matt Mackall wrote:
> On Thu, 2008-10-30 at 05:49 +0100, Nick Piggin wrote:
> > I still think we should get rid of the guard pages in non-debug kernels
> > completely,
> 
> For what it's worth, I agree.
Do we want any specific option, or is DEBUG_VM enough ?

> 
> -- 
> Mathematics is the supreme nostalgia of our time.
> 
