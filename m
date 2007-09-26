Return-Path: <linux-kernel-owner+w=401wt.eu-S1757146AbXIZK1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146AbXIZK1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 06:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbXIZK1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 06:27:43 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:34330 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbXIZK1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 06:27:42 -0400
Message-ID: <46FA341A.80706@davidnewall.com>
Date: Wed, 26 Sep 2007 19:57:38 +0930
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Kyle Moffett <mrmacman_g4@mac.com>
CC: Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Serge E. Hallyn" <serge@hallyn.com>, Bill Davidsen <davidsen@tmr.com>,
       Philipp Marek <philipp@marek.priv.at>, 7eggert@gmx.de,
       majkls <majkls@prepere.com>, bunk@fs.tum.de,
       linux-kernel@vger.kernel.org
Subject: Re: Chroot bug
References: <46F83474.5040503@davidnewall.com> <20070924230008.GA3160@vino.hallyn.com> <46F8BC8A.7080006@davidnewall.com> <20070925114947.GA9721@vino.hallyn.com> <46F91417.9050600@davidnewall.com> <46F924E3.50205@davidnewall.com> <20070925163040.12a3c2f8@the-village.bc.nu> <46F92AAB.1060903@davidnewall.com> <20070925164806.4cadc6a5@the-village.bc.nu> <46F99EDE.70905@davidnewall.com> <20070926005551.GS6800@stusta.de> <F23AFB4D-E989-4F06-A256-4D12D852DFA2@mac.com>
In-Reply-To: <F23AFB4D-E989-4F06-A256-4D12D852DFA2@mac.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
> David, please do tell myself and Adrian how "locking down" chroot() 
> the way you want will avoid letting root break out through any of the 
> above ways?

As has been said, there are thousands of ways to break out of a chroot.  
It's just that one of them should not be that chroot lets you walk out.  
I can't explain it clearer than that.  If you don't see it now you 
probably never will.
