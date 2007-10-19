Return-Path: <linux-kernel-owner+w=401wt.eu-S1764666AbXJSHVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764666AbXJSHVH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 03:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbXJSHUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 03:20:55 -0400
Received: from rzcomm22.rz.tu-bs.de ([134.169.9.68]:60662 "EHLO
	rzcomm22.rz.tu-bs.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbXJSHUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 03:20:55 -0400
X-Greylist: delayed 853 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Oct 2007 03:20:54 EDT
Message-ID: <47185722.8020606@l4x.org>
Date: Fri, 19 Oct 2007 09:05:06 +0200
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, Mark Lord <lkml@rtr.ca>
Subject: Re: libata crash
References: <20071018164745.GD10674@kernel.dk> <20071018192839.GA17247@elte.hu> <20071018193236.GJ10674@kernel.dk> <20071018195903.GA29567@elte.hu> <20071018204111.GN10674@kernel.dk> <4717C776.5020809@garzik.org>
In-Reply-To: <4717C776.5020809@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Building on x86-64, I'm betting?  :)
> 
> I fell victim to the same thing a few days ago, missing some compile 
> breakage that only appeared with
> 
>     make ARCH=i386 allmodconfig && make ARCH=i386 -sj9
> 
> Though am I alone in dreaming of a kernel.org service that would permit 
> all-arch build testing of a git URL?

I could add that to the service at http://l4x.org/k/ if there is
sufficient (>1) interest.

Jan
