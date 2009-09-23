Return-Path: <linux-kernel-owner+w=401wt.eu-S1751685AbZIWNrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685AbZIWNrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 09:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbZIWNrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 09:47:40 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:46017 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751541AbZIWNrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 09:47:40 -0400
Date: Wed, 23 Sep 2009 09:46:37 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: Hirokazu Takata <takata@linux-m32r.org>
cc: torvalds@linux-foundation.org, linux-m32r@ml.linux-m32r.org,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [GIT PULL] m32r: Cleanup linker script
In-Reply-To: <swfk4zqnyv7.wl%takata@linux-m32r.org>
Message-ID: <alpine.DEB.1.10.0909230021320.15822@dr-wily.mit.edu>
References: <swfljk6ooe0.wl%takata@linux-m32r.org> <swfk4zqnyv7.wl%takata@linux-m32r.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Sep 2009, Hirokazu Takata wrote:

> Hi, Linus,
> 
> Sorry, there was a cross in the post.
> 
> I was not conscious of Sam's acknowledgement mail.  And a newer patchset
> has been sent by Tim Abbott on Sep. 22, 2009 - 10:23:21 EST.
> 
> > [PATCH 00/13] Linker script cleanup patches for various architectures
> 
> The newer patchset includes updates for not only m32r but also
> parisc, xtenza, h8300, mn10300 and um.
> 
> What do I deal with such a cross architectural patchset?

Sorry for the miscommunication.

My patchset is just 5 orthogonal patchsets included together; there's no 
dependence between the various architectures.  These were just the subset 
of the architecture linker script cleanups that were ready to be merged at 
that time.

The 6 m32r patches I sent to Linus are exactly the same as what's in your 
pull request, so it doesn't matter which one gets merged.

	-Tim Abbott
