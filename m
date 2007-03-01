Return-Path: <linux-kernel-owner+w=401wt.eu-S1030266AbXCAVI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030266AbXCAVI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 16:08:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030269AbXCAVI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 16:08:58 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56642 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030266AbXCAVI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 16:08:58 -0500
Date: Thu, 1 Mar 2007 21:08:29 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Richard Purdie <rpurdie@rpsys.net>
cc: David Miller <davem@davemloft.net>, Joel.Becker@oracle.com,
       lists@onerussian.com, akpm@linux-foundation.org,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] no backlight on radeon after recent kernel
 "upgrade"s
In-Reply-To: <1172746678.19220.48.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0703012107590.14408@pentafluge.infradead.org>
References: <Pine.LNX.4.64.0702220109450.17121@pentafluge.infradead.org> 
 <20070222020951.GR7920@ca-server1.us.oracle.com> 
 <Pine.LNX.4.64.0702221549530.29542@pentafluge.infradead.org> 
 <20070222.092812.112620509.davem@davemloft.net> 
 <Pine.LNX.4.64.0702281654230.14127@pentafluge.infradead.org>
 <1172746678.19220.48.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Could you. Right now I'm busy with the DRM/fbdev device management.

On Thu, 1 Mar 2007, Richard Purdie wrote:

> On Wed, 2007-02-28 at 16:55 +0000, James Simmons wrote:
> > So the problem is not the configuration but that for some reason the 
> > backlight state is set to off by default.
> 
> Maybe, maybe not. I'm not sure there's been enough information to
> conclude that.
> 
> At the moment, I'd like a patch which makes backlight usage configurable
> at runtime though a module parameter and defaults to off in all cases
> except the powermac one. I'd like to get something into the tree,
> preferably before the next -rc, since at the moment things are breaking
> for people. If you haven't time, say so and I'll have a look and see if
> I can work one out.
> 
> Cheers,
> 
> Richard
> 
> 
> 
> 
> 
