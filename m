Return-Path: <linux-kernel-owner+w=401wt.eu-S1760808AbXGRJJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760808AbXGRJJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 05:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754994AbXGRJJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 05:09:45 -0400
Received: from colin.muc.de ([193.149.48.1]:4710 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591AbXGRJJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 05:09:44 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jul 2007 05:09:44 EDT
Date: 18 Jul 2007 11:03:02 +0200
Date: Wed, 18 Jul 2007 11:03:02 +0200
From: Andi Kleen <ak@muc.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] Standardize x86_64's desc_defs.h in preparation for exposure to i386.
Message-ID: <20070718090302.GA67073@muc.de>
References: <1184743355.10380.112.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184743355.10380.112.camel@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2007 at 05:22:34PM +1000, Rusty Russell wrote:
> However, the currently (i386-derived) x86-64 ones are suboptimal.  The

In what way are they suboptimal? 

They seem to work just fine.

-Andi

