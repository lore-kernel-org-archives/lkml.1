Return-Path: <linux-kernel-owner+w=401wt.eu-S1752402AbXB1QyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402AbXB1QyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 11:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbXB1QyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 11:54:19 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44757 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbXB1QyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 11:54:18 -0500
Date: Wed, 28 Feb 2007 16:54:00 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: linux-fbdev-devel@lists.sourceforge.net
cc: Paul Sokolovsky <pmiscml@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH 1/1] PXAFB: Support for backlight
 control
In-Reply-To: <20070222163727.GV13924@enneenne.com>
Message-ID: <Pine.LNX.4.64.0702281653420.14127@pentafluge.infradead.org>
References: <20070221145353.GA23916@enneenne.com> <1056908425.20070221180037@gmail.com>
 <20070221161210.GL4641@enneenne.com> <1741775233.20070221182608@gmail.com>
 <20070222083204.GN4641@enneenne.com> <1868738509.20070222123335@gmail.com>
 <20070222163727.GV13924@enneenne.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> On Thu, Feb 22, 2007 at 12:33:35PM +0200, Paul Sokolovsky wrote:
> > 
> >   We in handhelds.org codebase have attached patch* to make corgi_bl
> > more suitable for general use. This patch was submitted to Richard
> > (so, more votes needed ;-) ). Otherwise, snippet I pasted is from real
> > machine implementation, HP iPaq h4000.
> 
> You have my vote! :)
> 
> So let me suggest this patch who allows multiple driver instances (I
> use it for both LCD and keypad backlighti devices).
> 
> Hope it could be merged into main line (maybe without the "corgi"
> prefix ;-).

Nice patch. I have no problem with it.

