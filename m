Return-Path: <linux-kernel-owner+w=401wt.eu-S1763195AbXGTVQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763195AbXGTVQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 17:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbXGTVQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 17:16:04 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44956 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756044AbXGTVQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 17:16:03 -0400
Date: Fri, 20 Jul 2007 23:16:00 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Juergen Beisert <juergen127@kreuzholzen.de>,
       Andres Salomon <dilinger@queued.net>,
       TAKADA Yoshihito <takada@mbf.nifty.com>, linux-kernel@vger.kernel.org,
       Jordan Crouse <jordan.crouse@amd.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/1] i386: Geode's TSC is not neccessary to mark tu unstable
Message-ID: <20070720211600.GA565@one.firstfloor.org>
References: <20070715.210036.157242351.takada@mbf.nifty.com> <200707191052.50047.juergen127@kreuzholzen.de> <200707191125.47079.ak@suse.de> <200707191225.26047.juergen127@kreuzholzen.de> <p73ir8gwl7g.fsf@bingen.suse.de> <20070720112118.0521ecf5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070720112118.0521ecf5.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > I fixed it all up
> 
> I have a sad little patch from Nick here which adds a new
> include/asm-x86_64/processor-cyrix.h.  I guess this patch broke the x86_64
> build.

I fixed that up too, but in a different way (just included asm-i386/processor-cyrix.h)

-Andi
