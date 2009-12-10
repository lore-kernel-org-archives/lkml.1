Return-Path: <linux-kernel-owner+w=401wt.eu-S1761774AbZLJX4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761774AbZLJX4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 18:56:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761741AbZLJX4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 18:56:52 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37395 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761731AbZLJX4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 18:56:51 -0500
Date: Thu, 10 Dec 2009 23:58:35 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephane Marchesin <stephane.marchesin@gmail.com>,
       Maarten Maathuis <madman2003@gmail.com>,
       Xavier Bestel <xavier.bestel@free.fr>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm
Message-ID: <20091210235835.20e2269d@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.0912101531180.3560@localhost.localdomain>
References: <alpine.DEB.2.00.0912100603070.24701@skynet.skynet.ie>
	<alpine.LFD.2.00.0912100716470.3560@localhost.localdomain>
	<1260459601.18520.26.camel@skunk>
	<alpine.LFD.2.00.0912100823220.3560@localhost.localdomain>
	<6d4bc9fc0912100940l1d2954d0k187ae54bf44a23f5@mail.gmail.com>
	<alpine.LFD.2.00.0912101035140.3560@localhost.localdomain>
	<6a89f9d50912101153l2b58b07fudf6965b2f5172f7f@mail.gmail.com>
	<alpine.LFD.2.00.0912101531180.3560@localhost.localdomain>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But not only is Fedora not following the rules, 

You changed the rules. You require a Signed-off-by:. Fedora can no more
add a signed off by than you can. It's not their code nor Red Hat's code
any more than they "own" the kernel because they pay someone to work on
it.

> See above. It's not you. It's Fedora. If Fedora hadn't merged Nouveau and 
> shipped it, I wouldn't care.

And zillions of Nvidia users would have been worse off.

It's really simple: if you want to merge it *you* pull it and sign it off.
If you aren't prepared to do that then ask why Fedora should, its not
their code either.

Alan
