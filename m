Return-Path: <linux-kernel-owner+w=401wt.eu-S1756445AbZLJT0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445AbZLJT0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 14:26:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753606AbZLJT0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 14:26:51 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42161 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753910AbZLJT0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 14:26:50 -0500
Date: Thu, 10 Dec 2009 19:28:01 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Maarten Maathuis <madman2003@gmail.com>,
       Xavier Bestel <xavier.bestel@free.fr>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm
Message-ID: <20091210192801.489f01b8@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.0912101035140.3560@localhost.localdomain>
References: <alpine.DEB.2.00.0912100603070.24701@skynet.skynet.ie>
	<alpine.LFD.2.00.0912100716470.3560@localhost.localdomain>
	<1260459601.18520.26.camel@skunk>
	<alpine.LFD.2.00.0912100823220.3560@localhost.localdomain>
	<6d4bc9fc0912100940l1d2954d0k187ae54bf44a23f5@mail.gmail.com>
	<alpine.LFD.2.00.0912101035140.3560@localhost.localdomain>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The fact is, if there are license questions, then Fedora had better not be 
> distributing the code either. And they clearly are.

Their choice, but it's not their project - they are just chosing to
import it.

> I've heard the "but it's hard to merge" excuse too - which I also know is 
> bullshit, because I can look at the git tree Fedora apparently uses, and 
> it merges without any conflicts what-so-ever.

So merge it - it's your call as the maintainer of the master tree - or put
it in staging and dike out the microcode - which is firmware tree stuff
*anyway*

Alan
