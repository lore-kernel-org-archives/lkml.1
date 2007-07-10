Return-Path: <linux-kernel-owner+w=401wt.eu-S1763911AbXGJSyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763911AbXGJSyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760123AbXGJSxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:53:45 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:57105 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758665AbXGJSxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:53:43 -0400
Date: Tue, 10 Jul 2007 20:54:15 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Rob Landley <rob@landley.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Kunai, Takashi" <kunai@linux-foundation.jp>,
       holzheu@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, lf_kernel_messages@linux-foundation.org,
       mtk-manpages@gmx.net, jack@suse.cz, randy.dunlap@oracle.com,
       gregkh@suse.de, pavel@ucw.cz, tim.bird@am.sony.com, gh@us.ibm.com,
       arjan@infradead.org, sam@ravnborg.org, jengelh@computergmbh.de,
       joe@perches.com, auke-jan.h.kok@intel.com, hansendc@us.ibm.com,
       davem@davemloft.net, Valdis.Kletnieks@vt.edu, kenistoj@us.ibm.com,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       linux-doc@vger.kernel.org
Subject: Re: Documentation of kernel messages (Summary)
Message-ID: <20070710185415.GA3492@stusta.de>
References: <1181747217.29512.9.camel@localhost.localdomain> <200707091248.24994.rob@landley.net> <20070709183309.GH3492@stusta.de> <200707101225.32843.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200707101225.32843.rob@landley.net>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 12:25:31PM -0400, Rob Landley wrote:
>...
> Let's look at _english_ documentation.
> 
> If you go to http://kernel.org/doc/ols you should find, nicely split up, all 
> the OLS papers from 2002-2007.  By my count, there are 337 of them, totaling 
> 61.8 megabytes when they're split up like that.  Being PDFs, they don't 
> compress all that well.
> 
> Which subset of these should be copied into the Documentation directory?

You don't have to copy everything.

And you anyway have to handle cases like e.g. most books where you are 
not permitted to copy them, but might want to point people to them.

> How 
> do you update them?  This is the documentation from just ONE SOURCE.

You aren't legally permitted to update any OLS paper unless you've 
gotten explicit permission by the author. And when he gives legal 
permission, he can as well give you the LaTeX source. I'd expect legal 
and technical update possibilities to usually be related this way.

And you shouldn't include non-free documentation into the kernel sources.

> And PDF isn't close to the worst of it: Linuxconf.au has lots of video, as 
> does google video.  (I don't even have _english_ transcripts for those 
> videos, which would be nice.)  Do you want to merge all of this into the 
> kernel tarball as well?

Not at all.

> How does this help keep anything up to date?

You can only update things you are legally and technically able to 
update. For the rest, you can only ship pointers like kernel-docs.txt.

> Rob

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

