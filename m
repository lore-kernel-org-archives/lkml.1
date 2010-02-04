Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757778Ab0BDVKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 16:10:00 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:51868 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355Ab0BDVJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 16:09:59 -0500
Date: Thu, 4 Feb 2010 21:09:50 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@linux.ie>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: hung bootup with "drm/radeon/kms: move radeon KMS on/off
	switch out of staging."
Message-ID: <20100204210950.GA25295@srcf.ucam.org>
References: <20100204175928.GA20595@srcf.ucam.org> <20100204181218.GA6175@elte.hu> <a728f9f91002041030o7c8d38edxe573bc0a1327d79@mail.gmail.com> <20100204190649.GB6665@elte.hu> <a728f9f91002041118m6415844fp1740f18fdc1c9757@mail.gmail.com> <20100204193232.GD6665@elte.hu> <20100204115316.69beee75@jbarnes-piketon> <20100204202254.GA24716@elte.hu> <20100204204829.GA24608@srcf.ucam.org> <20100204210559.GC19050@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100204210559.GC19050@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 10:05:59PM +0100, Ingo Molnar wrote:

> Regressions are not limited to 'same config' kernels, last i checked. If that 
> has changed (or if i'm misunderstanding it) then it would be nice to hear a 
> clarification about that from Linus.

If an option has *never* worked on a given configuration, then it's not 
a regression. That's not a matter of taste, it's a matter of language. 
We prioritise regressions because they mean that someone's previously 
working configuration no longer works. Tying the word "regression" to 
other bugs just to get someone to look at them faster is 
counterproductive.
 
-- 
Matthew Garrett | mjg59@srcf.ucam.org
