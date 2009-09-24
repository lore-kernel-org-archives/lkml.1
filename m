Return-Path: <linux-kernel-owner+w=401wt.eu-S1752180AbZIXO1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbZIXO1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbZIXO1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:27:47 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60113 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751282AbZIXO1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:27:46 -0400
Date: Thu, 24 Sep 2009 10:27:06 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: torvalds@linux-foundation.org
cc: linux-m32r@ml.linux-m32r.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>,
       Hirokazu Takata <takata@linux-m32r.org>
Subject: Re: [GIT PULL] m32r: Cleanup linker script
In-Reply-To: <alpine.DEB.1.10.0909230021320.15822@dr-wily.mit.edu>
Message-ID: <alpine.DEB.1.10.0909241023340.10348@dr-wily.mit.edu>
References: <swfljk6ooe0.wl%takata@linux-m32r.org> <swfk4zqnyv7.wl%takata@linux-m32r.org> <alpine.DEB.1.10.0909230021320.15822@dr-wily.mit.edu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Sep 2009, Tim Abbott wrote:

> On Wed, 23 Sep 2009, Hirokazu Takata wrote:
> 
> > Hi, Linus,
> > 
> > Sorry, there was a cross in the post.
> > 
> > I was not conscious of Sam's acknowledgement mail.  And a newer patchset
> > has been sent by Tim Abbott on Sep. 22, 2009 - 10:23:21 EST.
> > 
> > > [PATCH 00/13] Linker script cleanup patches for various architectures
> > 
> > The newer patchset includes updates for not only m32r but also
> > parisc, xtenza, h8300, mn10300 and um.
...
> The 6 m32r patches I sent to Linus are exactly the same as what's in your 
> pull request, so it doesn't matter which one gets merged.

Since I'm resending that patch series to Linus for other reasons today, 
I'm going to drop the m32r patches from it (so Linus should merge these 
m32r linker script cleanups from the pull request).

Sorry again for the confusion.

	Best regards,
	-Tim Abbott
