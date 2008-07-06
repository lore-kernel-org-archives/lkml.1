Return-Path: <linux-kernel-owner+w=401wt.eu-S1760068AbYGFVNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760068AbYGFVNA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 17:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757623AbYGFVMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 17:12:53 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:42213 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756685AbYGFVMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 17:12:52 -0400
Date: Sun, 6 Jul 2008 23:13:40 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Sebastian Siewior <lkml@ml.breakpoint.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux fatal: cannot describe <sha1>
Message-ID: <20080706211340.GB7425@uranus.ravnborg.org>
References: <alpine.LNX.1.10.0807011817230.20393@fbirervta.pbzchgretzou.qr> <20080701200951.GB10677@uranus.ravnborg.org> <20080701221808.GA26272@Chamillionaire.breakpoint.cc> <alpine.LNX.1.10.0807051454470.28765@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0807051454470.28765@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 05, 2008 at 02:58:48PM +0200, Jan Engelhardt wrote:
> On Wednesday 2008-07-02 00:18, Sebastian Siewior wrote:
> >* Sam Ravnborg | 2008-07-01 22:09:51 [+0200]:
> >
> >>> Just a note that when you run git-describe, you should probably quiten it.
> >>> 
> >>> fatal: cannot describe 'bd7364a0fd5a4a2878fe4a224be1b142a4e6698e'
> >>> 
> >>
> >>Hi Jan.
> >>
> >>Any specific reason why you sent it to me?
> 
> You are the buildsystem maintainer :)
> 
> >Maybe he was thinking about this (and didn't know that you were moving):
> 
> I only took note of that briefly. Should there have been someone
> else to send it to?
I just failed to see the connection to kbuild - I had long
forgotten that we uses git describe in setlocalversion script.

	Sam
