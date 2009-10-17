Return-Path: <linux-kernel-owner+w=401wt.eu-S1752779AbZJQQKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbZJQQKx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 12:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbZJQQKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 12:10:53 -0400
Received: from the.earth.li ([217.147.81.2]:42317 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbZJQQKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 12:10:52 -0400
Date: Sat, 17 Oct 2009 09:10:56 -0700
From: Jonathan McDowell <noodles@earth.li>
To: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: X hangs with blank screen on 2.6.32-rc4 / Intel 915GM
Message-ID: <20091017161056.GA7149@earth.li>
References: <20091016005319.GC5658@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091016005319.GC5658@earth.li>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 15, 2009 at 05:53:19PM -0700, Jonathan McDowell wrote:
> Trying 2.6.32-rc4 on my Toshiba R200 laptop running Debian Squeeze
> leads to a blank screen with a flashing cursor in the top left when X
> starts.  If startup in such a way that X isn't automatically started
> the console is fine, but starting X manually still leads to the hang.
> The machine seems unresponsive at this point - I can't switch to a
> normal console and the laptop fan comes on in a manner that suggests
> the CPU is chugging away.
> 
> 2.6.31.4 works fine.

And 2.6.32-rc5 works again, so this is no longer an issue as far as
I'm concerned.

J.

-- 
/-\                             |    I wish life had a scroll-back
|@/  Debian GNU/Linux Developer |               buffer.
\-                              |
