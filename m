Return-Path: <linux-kernel-owner+w=401wt.eu-S1764217AbXHPGch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764217AbXHPGch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 02:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbXHPGc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 02:32:28 -0400
Received: from 1wt.eu ([62.212.114.60]:1699 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbXHPGc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 02:32:27 -0400
Date: Thu, 16 Aug 2007 08:29:08 +0200
From: Willy Tarreau <w@1wt.eu>
To: Thorsten Leemhuis <fedora@leemhuis.info>
Cc: linux-kernel@vger.kernel.org, Adrian Bunk <bunk@stusta.de>,
       stable@kernel.org
Subject: Re: no announce mails for "older" stable-releases on linux-kernel-announce (Was: Re: Linux 2.6.20.16)
Message-ID: <20070816062908.GA1620@1wt.eu>
References: <20070816054357.GA22242@hera.kernel.org> <46C3EAB7.2000503@leemhuis.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C3EAB7.2000503@leemhuis.info>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2007 at 08:12:07AM +0200, Thorsten Leemhuis wrote:
> On 16.08.2007 07:43, Willy Tarreau wrote:
> > I've just released Linux 2.6.20.16. This version catches up with 2.6.21.7.
> > I hope to issue newer releases soon with next batches of pending patches.
> > 
> > I'll also be replying to this message with a copy of the patch between
> > 2.6.20.15 and 2.6.20.16.
> > [...]
> 
> Just wondering -- Kernels like this (or 2.6.16.x, 2.6.21.x as well as
> 2.6.22.x once 2.6.23 got released) don't get announced on
> linux-kernel-announce. Is that on purpose or a misbehavior of scripts
> that create the messages for linux-kernel-announce?

even simpler : I've never been aware of linux-kernel-announce. It's
possible that only Linus sends there and that even the -stable team
does not use/know about it either.

> If the latter: are those scripts available somewhere?

we all have somewhat different scripts. Those scripts do 80% of the work
depending on our environments, mostly in order to avoid common mistakes,
and we do the remaining 20% by hand. Anyway I think it's not difficult
for any of us to add a new address.

(CCing -stable and Adrian in case they miss your mail)

Regards,
willy

