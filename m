Return-Path: <linux-kernel-owner+w=401wt.eu-S966591AbXEGU1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966591AbXEGU1Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966586AbXEGU1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:27:20 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:54733 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966576AbXEGU1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:27:19 -0400
Date: Mon, 7 May 2007 22:28:13 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: why don't top-level menu entries have help info?
Message-ID: <20070507202813.GA20680@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0705071548240.29393@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705071548240.29393@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Added Roman Zippel to cc - he is kconfig maintainer,

	Sam

On Mon, May 07, 2007 at 03:54:13PM -0400, Robert P. J. Day wrote:
> 
>   i'd be surprised if this hasn't come up before, but would it be hard
> to add a facility to Kconfig so that "menu" entries have some help
> info?
> 
>   after i run "make menuconfig" and i'm sitting at the main menu,
> there's nothing to help me out in understanding what any of those
> choices might mean.
> 
>   i might see "Instrumentation Support" and wonder just what that is,
> but if i ask for help (which is, as you can see, clearly available
> at the bottom of the config screen), i get nothing meaningful, just
> the generic README.
> 
>   i think it would be helpful if those entries also supported help
> info.  just my $0.02.
> 
> rday
> 
> -- 
> ========================================================================
> Robert P. J. Day
> Linux Consulting, Training and Annoying Kernel Pedantry
> Waterloo, Ontario, CANADA
> 
> http://fsdev.net/wiki/index.php?title=Main_Page
> ========================================================================
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
