Return-Path: <linux-kernel-owner+w=401wt.eu-S1757400AbXGIScr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbXGIScr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 14:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbXGIScj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 14:32:39 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:55828 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752419AbXGISci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 14:32:38 -0400
Date: Mon, 9 Jul 2007 20:33:09 +0200
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
Message-ID: <20070709183309.GH3492@stusta.de>
References: <1181747217.29512.9.camel@localhost.localdomain> <4691C480.5010600@linux-foundation.jp> <4691C95F.7080502@zytor.com> <200707091248.24994.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200707091248.24994.rob@landley.net>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2007 at 12:48:24PM -0400, Rob Landley wrote:
>...
> [regarding translated documentation]
> 
> For my part, I can't _tell_ when a given translation is out of date because I 
> can't read it, and I certainly can't update it.  So I agree with Eric and I'm 
> linking to sites hosting kernel documentation in other languages rather than 
> hosting them myself.  I've got a good link to a Japanese site, need to ping 
> the contributors of the chinese documentation and see if they have a site for 
> it...
>...

Include the last git commit on this file in the translated document?

This would also make it easier for a translator to update a document 
because a diff on the original document since the last translation would 
be trivial.

> Rob

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

