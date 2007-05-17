Return-Path: <linux-kernel-owner+w=401wt.eu-S1761192AbXEQHGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761192AbXEQHGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 03:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754880AbXEQHGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 03:06:11 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:57731 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754783AbXEQHGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 03:06:10 -0400
Date: Thu, 17 May 2007 09:07:06 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-kernel@vger.kernel.org, ralf@linux-mips.org, rmk@arm.linux.org.uk
Subject: Re: [PATCH] kbuild: make better section mismatch reports on i386 and mips
Message-ID: <20070517070706.GA3690@uranus.ravnborg.org>
References: <20070515.004035.21363504.anemo@mba.ocn.ne.jp> <20070515204754.GD22966@uranus.ravnborg.org> <20070517.011438.126573550.anemo@mba.ocn.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070517.011438.126573550.anemo@mba.ocn.ne.jp>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 01:14:38AM +0900, Atsushi Nemoto wrote:
> On Tue, 15 May 2007 22:47:54 +0200, Sam Ravnborg <sam@ravnborg.org> wrote:
> > > Now modpost can detect "kernel_init" name (and whitelist it) and show
> > > "set_up_list3s" name.
> > 
> > Applied.
> > It seems arm is impacted by the same.
> > Can you add arm support for the same?
> 
> OK, revised with ARM support (and minor cleanups).

Thanks, I added this patch instead.
Tested on arm and it works.

	Sam
