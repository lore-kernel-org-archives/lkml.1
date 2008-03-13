Return-Path: <linux-kernel-owner+w=401wt.eu-S1756564AbYCMVSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbYCMVSF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 17:18:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbYCMVRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 17:17:55 -0400
Received: from the.earth.li ([217.147.81.2]:42953 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477AbYCMVRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 17:17:54 -0400
Date: Thu, 13 Mar 2008 21:17:49 +0000
From: Simon Huggins <huggie@earth.li>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: Scheduler broken? sdhci issues with scheduling
Message-ID: <20080313211749.GN28693@paranoidfreak.co.uk>
References: <20080229115256.GG24533@paranoidfreak.co.uk> <20080302104031.GB3861@ucw.cz> <20080303204300.69cbe392@mjolnir.drzeus.cx> <20080303203808.GH13869@elf.ucw.cz> <20080303220530.49201544@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303220530.49201544@mjolnir.drzeus.cx>
X-Attribution: huggie
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'ello Pierre

On Mon, Mar 03, 2008 at 10:05:30PM +0100, Pierre Ossman wrote:
> On Mon, 3 Mar 2008 21:38:08 +0100
> Pavel Machek <pavel@ucw.cz> wrote:
> > On Mon 2008-03-03 20:43:00, Pierre Ossman wrote:
> > > The problem is that the kernel sleeps _less_ than asked for, not more. No hardware can be expected to work if its needed delays aren't respected.
> > Oops, that's bad. Can you perhaps create small testcase for
> > scheduler/timer people to play with?
> > Also... you may want to switch timesources. notsc fixed "wait for much
> > too long" for me.
> I'm afraid I could never reproduce the problem. So it's Simon that
> will have to do the tests for now..

I'm happy to test bits.  What do I need to do to switch time sources for
instance?


Simon

-- 
... <ICv6> note pour plus tard... jamais paster un /quit dans un client irc
    =)
