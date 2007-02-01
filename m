Return-Path: <linux-kernel-owner+w=401wt.eu-S1030533AbXBAESQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030533AbXBAESQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 23:18:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030536AbXBAESQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 23:18:16 -0500
Received: from kallisti.us ([67.59.168.233]:3533 "EHLO kallisti.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030533AbXBAESP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 23:18:15 -0500
X-Greylist: delayed 825 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Jan 2007 23:18:15 EST
From: Ross Vandegrift <ross@kallisti.us>
Date: Wed, 31 Jan 2007 23:02:24 -0500
To: Valdis.Kletnieks@vt.edu
Cc: wsl3@lrsehosting.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>, alan@redhat.com,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: Unidentified Intel wifi network card
Message-ID: <20070201040224.GD20418@kallisti.us>
References: <1170264624.5569.15.camel@scott-640m> <200701312054.l0VKstxg020891@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200701312054.l0VKstxg020891@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 31, 2007 at 03:54:55PM -0500, Valdis.Kletnieks@vt.edu wrote:
> Only gotcha I know of:  Sometimes one of the ipw3945d kernel threads will
> hang in a loop if the RFKill switch is set to "kill" when the system comes
> up.  I also don't know how it handles suspend, I don't use that on my D820.

I have a D820 and I had a horrible time with the wireless for a long
time.  Every five minutes or so, the card would flip out and burn 100%
CPU making the box unusable for 15-45 seconds.

The most recent version of the firmware fixed this issue and now
things are much better.

-- 
Ross Vandegrift
ross@kallisti.us

"The good Christian should beware of mathematicians, and all those who
make empty prophecies. The danger already exists that the mathematicians
have made a covenant with the devil to darken the spirit and to confine
man in the bonds of Hell."
	--St. Augustine, De Genesi ad Litteram, Book II, xviii, 37
