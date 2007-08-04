Return-Path: <linux-kernel-owner+w=401wt.eu-S1762662AbXHDDuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762662AbXHDDuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 23:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763713AbXHDDtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 23:49:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47921 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763461AbXHDDtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 23:49:51 -0400
Date: Fri, 3 Aug 2007 20:52:06 -0700
From: Greg KH <gregkh@suse.de>
To: Rob Landley <rob@landley.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Theodore Tso <tytso@mit.edu>, leoli@freescale.com,
       Gerrit Huizenga <gh@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Kunai, Takashi" <kunai@linux-foundation.jp>,
       holzheu@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, lf_kernel_messages@linux-foundation.org,
       mtk-manpages@gmx.net, jack@suse.cz, pavel@ucw.cz, tim.bird@am.sony.com,
       arjan@infradead.org, sam@ravnborg.org, jengelh@computergmbh.de,
       joe@perches.com, auke-jan.h.kok@intel.com, hansendc@us.ibm.com,
       davem@davemloft.net, Valdis.Kletnieks@vt.edu, kenistoj@us.ibm.com,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       linux-doc@vger.kernel.org
Subject: Re: Documentation of kernel messages (Summary)
Message-ID: <20070804035206.GB23330@suse.de>
References: <E1I7wsz-0007oJ-DE@w-gerrit.beaverton.ibm.com> <200707161553.07813.rob@landley.net> <20070803111155.fe9281f6.rdunlap@xenotime.net> <200708031432.05714.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708031432.05714.rob@landley.net>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 03:32:04PM -0400, Rob Landley wrote:
> 
> These days I'm trying to create an html index that links into Documentation in 
> a coherent order (with categories and everything), and using automated tools 
> to detect files that aren't linked to, or links that point to a file that 
> isn't there anymore.  This is obviously still a work in progress, but I think 
> it's a better approach.

Better than cleaning up what we have in the kernel source tree?  Why not
work on that first, then the "automated" type stuff would be much easier
to do later, right?

thanks,

greg k-h
