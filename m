Return-Path: <linux-kernel-owner+w=401wt.eu-S1755501AbYKPW2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501AbYKPW2s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 17:28:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753922AbYKPW2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 17:28:39 -0500
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:58320 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232AbYKPW2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 17:28:38 -0500
Date: Sun, 16 Nov 2008 23:31:19 +0100
From: Samuel Ortiz <sameo@openedhand.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Mark Brown <broonie@sirena.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power_supply: Add support for WM8350 PMU
Message-ID: <20081116223118.GC2977@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <1226416083-12875-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20081112164722.GB3882@sortiz.org> <20081112164900.GJ8767@sirena.org.uk> <20081112165705.GC3882@sortiz.org> <20081114012050.GA21272@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081114012050.GA21272@zarina>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 04:20:50AM +0300, Anton Vorontsov wrote:
> On Wed, Nov 12, 2008 at 05:57:06PM +0100, Samuel Ortiz wrote:
> > On Wed, Nov 12, 2008 at 04:49:01PM +0000, Mark Brown wrote:
> > > On Wed, Nov 12, 2008 at 05:47:23PM +0100, Samuel Ortiz wrote:
> > > 
> > > > The MFD part looks good to me: 
> > > > > Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > > > Acked-by: Samuel Ortiz <sameo@openedhand.com>
> > > 
> > > I forgot to mention it on the repost (I did on the original) 
> > Ah, sorry..
> > 
> > 
> > > that since
> > > this depends on the AUXADC support queued in the MFD tree it probably
> > > makes sense to merge it via there.  Would you be OK with that if Anton
> > > OKs the driver?
> > I'll queue it once I get Anton's ACK, no problem.
> 
> The patch looks OK.
> 
> Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>
Thanks Mark, Anton. Patch applied to my for-next branch.

Cheers,
Samuel.

 
> 
> Thanks,
> 
> -- 
> Anton Vorontsov
> email: cbouatmailru@gmail.com
> irc://irc.freenode.net/bd2

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
