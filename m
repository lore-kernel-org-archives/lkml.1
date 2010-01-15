Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab0AONJL (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 08:09:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019Ab0AONJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 08:09:10 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46481 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752964Ab0AONJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 08:09:09 -0500
Date: Fri, 15 Jan 2010 13:10:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: James Simmons <jsimmons@infradead.org>
Cc: Alex Deucher <alexdeucher@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        David John <davidjon@xenontk.org>, Johan Hovold <jhovold@gmail.com>,
        linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        dri-devel@lists.sourceforge.net
Subject: Re: [PATCH] drm/kms: fix fbdev blanking regression
Message-ID: <20100115131047.41e7fa5e@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.1001151240030.2651@casper.infradead.org>
References: <1262797226-9593-1-git-send-email-jhovold@gmail.com>
	<1262797226-9593-2-git-send-email-jhovold@gmail.com>
	<alpine.LFD.2.00.1001061710510.5372@casper.infradead.org>
	<20100106180950.GD10442@localhost>
	<alpine.LFD.2.00.1001061814360.5372@casper.infradead.org>
	<20100106191234.GE10442@localhost>
	<4B458209.2030600@xenontk.org>
	<alpine.LFD.2.00.1001121645570.9778@casper.infradead.org>
	<20100112093454.57176b8c@jbarnes-piketon>
	<alpine.LFD.2.00.1001131947340.17662@casper.infradead.org>
	<a728f9f91001131201k6ba53710jdf85c1e38a937901@mail.gmail.com>
	<alpine.LFD.2.00.1001151240030.2651@casper.infradead.org>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jan 2010 12:40:30 +0000 (GMT)
James Simmons <jsimmons@infradead.org> wrote:

> 
> > > Yeap. I can have patch ready for you this weekend. I lack the hardware to
> > > test it tho. Never been able to find a intel pci card that is not built
> > > into the motherboard.
> > 
> > They don't exist, other than the old i740s.
> 
> I noticed the same is true for SiS cards.

SiS 6326 is a plug in card. Also prehistoric. I did a basic DRM for one
before deciding it would be faster to use the CPU (or indeed crayons ;))
