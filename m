Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385AbZAZSK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbZAZSK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 13:10:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbZAZSKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 13:10:45 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:49627 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751656AbZAZSKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 13:10:44 -0500
X-Greylist: delayed 1429 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Jan 2009 13:10:44 EST
Date: Mon, 26 Jan 2009 12:46:54 -0500
To: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Stop scaring users with "treason uncloaked!"
Message-ID: <20090126174654.GA26064@csclub.uwaterloo.ca>
References: <E1LDRbc-0000Ro-1j@gondolin.me.apana.org.au> <1229641573.3726.563.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229641573.3726.563.camel@calx>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2008 at 05:06:13PM -0600, Matt Mackall wrote:
> No one has printer ports any more so it hardly seems worth the trouble.

USB printers go through the same code.

> Most people won't actually think their printer is on fire. But most
> people WILL think there is serious cause for concern when they see this
> for the first time in dmesg. Many will search the net for explanations
> and come away confused and not entirely reassured. And at least one
> clueless guy will call the police because he still thinks he's under
> attack.

I dealt with an epson inkjet (USB based) a few years ago that would
reliably trigger that message when it was out of ink.  I thought it was
ammusing that they picked that signal to indicate out of ink.

Not sure if current models do it too.

> Now that certainly fits my definition of amusing and if my goal for
> Linux was to amuse myself at the expense of users, I'd be all for
> keeping it[1]. But perversely, I actually want users to enjoy their
> Linux experience.
> 
> [1] Hell, I'd probably even get them to use git.

-- 
Len Sorensen
