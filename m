Return-Path: <linux-kernel-owner+w=401wt.eu-S1758860AbZBFTar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860AbZBFTar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 14:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbZBFTah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 14:30:37 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:59377 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbZBFTag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 14:30:36 -0500
Date: Fri, 6 Feb 2009 21:30:27 +0200
From: Felipe Balbi <me@felipebalbi.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: me@felipebalbi.com, Bryan Wu <cooloney@kernel.org>, felipe.balbi@nokia.com,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: musb: tweak musb_read_fifo() to avoid unused
	warnings
Message-ID: <20090206193027.GF10711@frodo>
Reply-To: me@felipebalbi.com
References: <1233915736-18506-1-git-send-email-cooloney@kernel.org> <20090206191558.GD10711@frodo> <8bd0f97a0902061124s3c44d39dmf306a44f0c16528d@mail.gmail.com> <20090206192629.GE10711@frodo> <8bd0f97a0902061128r70cecec3p4c927f2daa38d517@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0902061128r70cecec3p4c927f2daa38d517@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 06, 2009 at 02:28:46PM -0500, Mike Frysinger wrote:
> >> the subject already says that
> >
> > the subject says:
> >
> > "tweak musb_read_fifo() to avoid unused warnings"
> >
> > it doesn't specify where are the warnings.
> 
> i dont think it really adds anything to explicitly mention every
> variable that triggers an unused warning.  but if we look at the code
> that changed, it's easy to see that it's epnum and dma_reg.

Still I like to see patch bodies otherwise git log will look awkward.

-- 
balbi
