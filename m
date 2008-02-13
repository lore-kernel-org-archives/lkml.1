Return-Path: <linux-kernel-owner+w=401wt.eu-S1758959AbYBMMGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758959AbYBMMGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 07:06:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757461AbYBMMGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 07:06:38 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:36117 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755305AbYBMMGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 07:06:36 -0500
Message-ID: <47B2DD40.70106@garzik.org>
Date: Wed, 13 Feb 2008 07:06:24 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       David Miller <davem@davemloft.net>, arjan@infradead.org,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
References: <20080211211751.3e265754@laptopd505.fenrus.org> <20080211.221126.230471463.davem@davemloft.net> <47B1CB08.4020101@garzik.org> <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org> <1202838082.3137.54.camel@localhost.localdomain> <alpine.LFD.1.00.0802120945290.2920@woody.linux-foundation.org> <1202840682.3137.83.camel@localhost.localdomain> <alpine.LFD.1.00.0802121037340.2920@woody.linux-foundation.org> <alpine.LFD.1.00.0802121051341.2920@woody.linux-foundation.org> <20080212191914.GB20883@kroah.com> <20080213100503.GA21694@flint.arm.linux.org.uk>
In-Reply-To: <20080213100503.GA21694@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> We know that the -mm tree is pretty much useless in terms of code
> coverage for ARM, and it's getting increasingly unlikely that anything
> short of a build of all ARM defconfigs will pick up on merge issues -
> which is a lot of CPU cycles, and I'm not going to insist its something
> that should be done.


If you need help in that area (build-testing ARM), surely we can find 
some fast machines that can do builds for you.  Any interest?

	Jeff



