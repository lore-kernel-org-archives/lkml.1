Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbYKLQyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbYKLQyf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 11:54:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbYKLQy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 11:54:27 -0500
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:55805 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbYKLQy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 11:54:26 -0500
Date: Wed, 12 Nov 2008 17:57:06 +0100
From: Samuel Ortiz <sameo@openedhand.com>
To: Mark Brown <broonie@sirena.org.uk>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power_supply: Add support for WM8350 PMU
Message-ID: <20081112165705.GC3882@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <1226416083-12875-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20081112164722.GB3882@sortiz.org> <20081112164900.GJ8767@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081112164900.GJ8767@sirena.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 04:49:01PM +0000, Mark Brown wrote:
> On Wed, Nov 12, 2008 at 05:47:23PM +0100, Samuel Ortiz wrote:
> 
> > The MFD part looks good to me: 
> > > Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > Acked-by: Samuel Ortiz <sameo@openedhand.com>
> 
> I forgot to mention it on the repost (I did on the original) 
Ah, sorry..


> that since
> this depends on the AUXADC support queued in the MFD tree it probably
> makes sense to merge it via there.  Would you be OK with that if Anton
> OKs the driver?
I'll queue it once I get Anton's ACK, no problem.

Cheers,
Samuel.


-- 
Intel Open Source Technology Centre
http://oss.intel.com/
