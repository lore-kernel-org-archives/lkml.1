Return-Path: <linux-kernel-owner+w=401wt.eu-S933460AbXDZIZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933460AbXDZIZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 04:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933604AbXDZIZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 04:25:24 -0400
Received: from mail.suse.de ([195.135.220.2]:44479 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933605AbXDZIZW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 04:25:22 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Daniel Barkalow <barkalow@iabervon.org>
Subject: Re: Linux 2.6.21
Date: Thu, 26 Apr 2007 10:03:59 +0200
User-Agent: KMail/1.9.1
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org> <20070426040806.GJ3468@stusta.de> <Pine.LNX.4.64.0704260133271.28708@iabervon.org>
In-Reply-To: <Pine.LNX.4.64.0704260133271.28708@iabervon.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704261004.00220.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 26. April 2007 08:46 schrieb Daniel Barkalow:
> On Thu, 26 Apr 2007, Adrian Bunk wrote:
> 
> > Number of different known regressions compared to 2.6.20 at the time
> > of the 2.6.21 release:
> > 14
> 
> I count 13. (v2) had 15 items, of which 2 were subsequently fixed or found 
> to be inapplicable.
> 
> > Number of different known regressions compared to 2.6.20 at the time
> > of the 2.6.21 release with patches available at the time of the 2.6.21 
> > release [1]:
> > 3
> 
> The -stable team can presumably take care of these in 2.6.21.1, right? 
> That leaves 10 that need developer attention.
> 
>  John Stultz seems to be taking care of 3 of them.
> 
>  Oliver Neukum has 1.

Which I haven't succeeded in reproducing and gotten no further info on.

	Regards
		Oliver
