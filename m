Return-Path: <linux-kernel-owner+w=401wt.eu-S1757259AbXEIOrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259AbXEIOrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 10:47:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbXEIOq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 10:46:57 -0400
Received: from canuck.infradead.org ([209.217.80.40]:53205 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbXEIOq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 10:46:57 -0400
Subject: Re: [PATCH 8/8] One Laptop Per Child power/battery driver
From: David Woodhouse <dwmw2@infradead.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Satyam Sharma <satyam.sharma@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Anton Vorontsov <cbou@mail.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <Pine.LNX.4.64N.0705091504360.15372@blysk.ds.pg.gda.pl>
References: <20070503213303.GH20067@zarina> <20070507140453.GD3868@ucw.cz>
	 <1178550653.11851.191.camel@pmac.infradead.org>
	 <20070507194949.GB3981@ucw.cz>
	 <a781481a0705071304m7f6d1b7ewa179e291f52689a4@mail.gmail.com>
	 <Pine.LNX.4.64N.0705081831070.30981@blysk.ds.pg.gda.pl>
	 <1178646751.2824.48.camel@pmac.infradead.org>
	 <Pine.LNX.4.64N.0705091504360.15372@blysk.ds.pg.gda.pl>
Content-Type: text/plain
Date: Wed, 09 May 2007 15:46:36 +0100
Message-Id: <1178721996.2824.199.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-09 at 15:23 +0100, Maciej W. Rozycki wrote:
>  I am pretty darn sure my name can be spelled correctly, but can it be 
> reasonably assured to be printed correctly on a reasonable subset of 
> systems out there?  

Yes. I haven't used a system on which it cannot for a number of years.

> Considering Linux only -- does our text-mode VGA console driver make
> any effort to print an arbitrary UTF-8-encoded text 
> correctly?  What does it do when it runs beyond the limit of 512 
> characters?  

I've no idea -- I haven't used the VGA text-mode console for years
either. I rarely even sit in front of a box on which it even works --
all the workstations I have these days are PowerPC, and use fbdev.

> And how about serial terminals?

It works fine over serial terminals. Why wouldn't it?

>  Until then I would rather work on code, sorry.  And that is not going to 
> be any code related to UTF-8 either, but I do encourage anybody who really 
> cares about it to address any or all issues raised above. :-)

You mean the VGA text console 'issue'? I might if I had suitable
hardware, or if it was important. But it isn't something that bothers
me.

-- 
dwmw2

