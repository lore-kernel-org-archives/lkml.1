Return-Path: <linux-kernel-owner+w=401wt.eu-S1758014AbZA2BFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014AbZA2BFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 20:05:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbZA2BFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 20:05:43 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45627 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbZA2BFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 20:05:43 -0500
Date: Wed, 28 Jan 2009 20:05:37 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: kyle@infradead.org, stable@kernel.org, arjan@linux.intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [stable] [PATCH stable] resources: skip sanity check of busy
	resources
Message-ID: <20090129010537.GA11255@bombadil.infradead.org>
References: <20090127161007.GG5034@bombadil.infradead.org> <20090129004306.GF23732@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129004306.GF23732@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 04:43:06PM -0800, Greg KH wrote:
> Thanks for the patch.  Next time, if you could let us know what the git
> commit id is for the patch in Linus's tree, it would save me having to
> dig to find it :)
> 

Doh, sorry, I thought I had passed -x to cherry-pick.

Will remember for next time.

cheers, Kyle
