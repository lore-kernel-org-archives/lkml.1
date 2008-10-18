Return-Path: <linux-kernel-owner+w=401wt.eu-S1751496AbYJRIRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496AbYJRIRn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 04:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750745AbYJRIR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 04:17:29 -0400
Received: from swm.pp.se ([212.247.200.143]:53159 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbYJRIR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 04:17:28 -0400
X-Greylist: delayed 1816 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Oct 2008 04:17:28 EDT
Date: Sat, 18 Oct 2008 09:47:10 +0200 (CEST)
From: Mikael Abrahamsson <swmike@swm.pp.se>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.28-rc1 --> 2.8.0-rc1; 2.6.27.y --> 2.6.28 [Re: [RFC] Kernel
 version numbering scheme change]
In-Reply-To: <20081018073810.GA7182@isilmar.linta.de>
Message-ID: <alpine.DEB.1.10.0810180940540.4948@uplift.swm.pp.se>
References: <20081016124943.GE23630@cs181140183.pp.htv.fi> <20081016151748.GA31075@kroah.com> <20081016153053.GJ5834@nostromo.devel.redhat.com> <20081016154726.GA6331@kroah.com> <20081016171626.GB22554@cs181140183.pp.htv.fi> <20081017040239.GB28188@kroah.com>
 <20081017103138.1ca68d17@lxorguk.ukuu.org.uk> <48F8C000.8030003@kernel.org> <20081017174226.GF2221@kroah.com> <48F98DE2.8030205@kernel.org> <20081018073810.GA7182@isilmar.linta.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
Organization: People's Front Against WWW
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Oct 2008, Dominik Brodowski wrote:

> Well, Linus hasn't yet changed SUBLEVEL or EXTRAVERSION[*]. But Adrian 
> has already stated that he will support what is known as 2.6.27 for a 
> long time. What about Linus naming the next release 2.8.0 (and move on 
> with 2.8.1, 2.8.2, ... with no special meaning to the numbers), so 
> instead of 2.6.28-rc1 it's 2.8.0-rc1. And once Adrian takes over from 
> the -stable team, he could release 2.6.28, 2.6.29 and so on when he 
> thinks a new minor number is appropriate, such as Willy intends to 
> release 2.4.37.

Unless we change the meaning of the numbers, I see little reason to bump 
to 2.8.

The only reason for change would be to merge 2.6 into 3, so we don't need 
2.6.29, 2.6.29.1, but instead we go to 3.0, 3.0.1, 3.0.2 and then 
3.1-rc1 becomes 3.1 and 3.1.1 is the next patch of it, and then 
3.2-rc1 etc. I don't see a problem to go over 9 on the second number 
either, so 3.23-rc1 is fine.

Makes it one less number to describe what kernel one is talking about. 
Saying 2.6.29.2 is a bit cumbersome, I'd much prefer 3.0.2.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
