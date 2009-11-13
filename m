Return-Path: <linux-kernel-owner+w=401wt.eu-S1753202AbZKMNLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbZKMNLt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 08:11:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbZKMNLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 08:11:45 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40660 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751800AbZKMNLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 08:11:44 -0500
Date: Fri, 13 Nov 2009 13:11:48 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       vikram pandita <vikram.pandita@ti.com>,
       Tony Lindgren <tony@atomide.com>
Subject: Re: linux-next: manual merge of the sound tree with the omap tree
Message-ID: <20091113131148.GC21516@rakim.wolfsonmicro.main>
References: <20091113131947.03d1b259.sfr@canb.auug.org.au>
 <20091113123901.GB30966@sirena.org.uk>
 <s5h1vk2po9n.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h1vk2po9n.wl%tiwai@suse.de>
X-Cookie: This end up.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 02:06:44PM +0100, Takashi Iwai wrote:
> Mark Brown wrote:

> > into the OMAP tree to resolve this.  There's some older ASoC changes in
> > there to ensure the patches applied but I'm happy for you to carry those
> > providing Takashi is.

> I can merge the tree above to for-next branch of sound git tree, too.
> In that way, we can keep asoc branches clean.

I believe that creates the same problem both ways :/ .  If we merge
OMAP->sound we may as well put it on the ASoC topic branch, it'll
probably be helpful for people doing OMAP work anyway.
