Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255Ab0AOMkj (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 07:40:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757429Ab0AOMki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 07:40:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:39475 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757147Ab0AOMkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 07:40:37 -0500
Date: Fri, 15 Jan 2010 12:40:30 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Alex Deucher <alexdeucher@gmail.com>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>, David John <davidjon@xenontk.org>,
        Johan Hovold <jhovold@gmail.com>, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>, dri-devel@lists.sourceforge.net
Subject: Re: [PATCH] drm/kms: fix fbdev blanking regression
In-Reply-To: <a728f9f91001131201k6ba53710jdf85c1e38a937901@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1001151240030.2651@casper.infradead.org>
References: <1262797226-9593-1-git-send-email-jhovold@gmail.com>  <1262797226-9593-2-git-send-email-jhovold@gmail.com>  <alpine.LFD.2.00.1001061710510.5372@casper.infradead.org>  <20100106180950.GD10442@localhost>  <alpine.LFD.2.00.1001061814360.5372@casper.infradead.org>
  <20100106191234.GE10442@localhost> <4B458209.2030600@xenontk.org>  <alpine.LFD.2.00.1001121645570.9778@casper.infradead.org>  <20100112093454.57176b8c@jbarnes-piketon>  <alpine.LFD.2.00.1001131947340.17662@casper.infradead.org>
 <a728f9f91001131201k6ba53710jdf85c1e38a937901@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Yeap. I can have patch ready for you this weekend. I lack the hardware to
> > test it tho. Never been able to find a intel pci card that is not built
> > into the motherboard.
> 
> They don't exist, other than the old i740s.

I noticed the same is true for SiS cards.

