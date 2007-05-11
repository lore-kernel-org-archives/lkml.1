Return-Path: <linux-kernel-owner+w=401wt.eu-S1760874AbXEKMnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760874AbXEKMnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 08:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757284AbXEKMnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 08:43:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58628 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055AbXEKMnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 08:43:24 -0400
Subject: Re: [PATCH 8/8] One Laptop Per Child power/battery driver
From: David Woodhouse <dwmw2@infradead.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Satyam Sharma <satyam.sharma@gmail.com>, Anton Vorontsov <cbou@mail.ru>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       kernel-discuss@handhelds.org, Andrew Morton <akpm@osdl.org>
In-Reply-To: <20070509203335.GA4290@ucw.cz>
References: <20070503213303.GH20067@zarina> <20070507140453.GD3868@ucw.cz>
	 <1178550653.11851.191.camel@pmac.infradead.org>
	 <20070507194949.GB3981@ucw.cz>
	 <a781481a0705071304m7f6d1b7ewa179e291f52689a4@mail.gmail.com>
	 <Pine.LNX.4.64N.0705081831070.30981@blysk.ds.pg.gda.pl>
	 <1178646751.2824.48.camel@pmac.infradead.org>
	 <Pine.LNX.4.64N.0705091504360.15372@blysk.ds.pg.gda.pl>
	 <1178721996.2824.199.camel@pmac.infradead.org>
	 <20070509203335.GA4290@ucw.cz>
Content-Type: text/plain
Date: Fri, 11 May 2007 13:43:22 +0100
Message-Id: <1178887402.21820.65.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-09 at 20:33 +0000, Pavel Machek wrote:
> Even with fbdev... you are limited to 512 characters iirc. So.. who
> has authority to say which subset of utf-8 is ok?

The user can load whatever font they want.

> (Plus there is still lot of vga consoles out there -- all fedora users
> afaict?)

No, most Fedora users use X -- and _everything_ in Fedora works fine
with UTF-8 and has done for years.

> > > And how about serial terminals?
> > 
> > It works fine over serial terminals. Why wouldn't it?
> 
> He probably means serial terminals... like physical vt100. I used to
> have one (vt302 compatible or something).  Most emulators still
> emulate vt100, and yes, vt100 predates utf-8. 

I have a serial terminal which can only do lower case (well, actually
capitals but it's all mapped to lower case since that's more useful).

When I write code on it, I can't do capital letters. But do I try to
_force_ you to use only capitals because of my limited terminal?

No. I don't. I can see what you've written just fine, within the
limitations of my terminal. 

So why are you trying to force me not to spell things correctly?

Go away.

-- 
dwmw2

