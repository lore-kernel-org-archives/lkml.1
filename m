Return-Path: <linux-kernel-owner+w=401wt.eu-S1755719AbZKKJe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbZKKJe3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 04:34:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbZKKJe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 04:34:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:55561 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbZKKJe1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 04:34:27 -0500
Subject: Re: Radeon KMS status (Re: [git pull] drm radeon kms.)
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net, glisse@freedesktop.org
In-Reply-To: <alpine.DEB.2.00.0911110910170.4943@skynet.skynet.ie>
References: <alpine.DEB.2.00.0911102313310.29664@skynet.skynet.ie>
	 <1257926475.23203.24.camel@twins>
	 <alpine.DEB.2.00.0911110910170.4943@skynet.skynet.ie>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 11 Nov 2009 10:33:48 +0100
Message-ID: <1257932028.23203.74.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-11 at 09:14 +0000, Dave Airlie wrote:
> > Hi Dave,
> > 
> > I was wondering about the current state of Radeon KMS, how far are we
> > from having it removed from staging?
> 
> I'm sort of thinking the next merge window of moving the enable option 
> into the kernel proper. We still have a metric shitload of work to get to 
> feature parity with current userspace drivers and we've done no 
> optimisation work on the rendering portion of the stack so I'm not sure 
> freezing the API isn't a bit premature, however maybe the API we have is 
> good enough to support and we can add new ioctls to make it go faster if 
> we require.
> 
> Jerome has proposed some API changes but we really haven't had time to 
> validate them in any useful way.

I by no means intend to rush things along, so if you think you need more
time, please take it ;-)

Just wanted to know where we stand... I'll try the Radeon KMS thing
again once I get through this mountain of email that accumulated over
the vacation and let you know how the current bits work.

Last time I tried KMS swapped the two DVI outputs wrt. the !KMS setup,
which is rather annoying during the transition period, but nothing I
can't live with once the stuff is stable enough to use all day.
