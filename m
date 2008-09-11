Return-Path: <linux-kernel-owner+w=401wt.eu-S1755238AbYIKL36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbYIKL36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 07:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbYIKL3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 07:29:50 -0400
Received: from mx1.moondrake.net ([212.85.150.166]:57584 "EHLO
	mx1.mandriva.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752563AbYIKL3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 07:29:49 -0400
X-Spam-Virus: No
To: David Miller <davem@davemloft.net>
Cc: dwmw2@infradead.org, jeffm@suse.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
X-URL: <http://www.mandrivalinux.com/
References: <48C68507.6000609@suse.com>
	<1221087719.13621.50.camel@macbook.infradead.org>
	<20080910.160505.14060698.davem@davemloft.net>
From: Thierry Vignaud <tvignaud@mandriva.com>
Organization: Mandriva
Date: Thu, 11 Sep 2008 13:29:46 +0200
In-Reply-To: <20080910.160505.14060698.davem@davemloft.net> (David Miller's message of "Wed\, 10 Sep 2008 16\:05\:05 -0700 \(PDT\)")
Message-ID: <m27i9i9az9.fsf@vador.mandriva.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> > This isn't compatible with the version of udev that people actually have
> > installed, today. And it's also the _wrong_ thing to do.
> > 
> > Firmware really _isn't_ version-specific.
> 
> Tell that to every Debian and Debian derived system on the planet.
> 
> To my knowledge, it is only fedora and possibly one or two other dists
> that put the firmware files in a unary /lib/firmware location, rather
> than a versioned /lib/firmware/$KERNELRELASE one.

We (Mandriva Linux) do too.
Why other distro cannot package firmware separatly for all their kernel
flavors?

Firmware are not version-specific.
