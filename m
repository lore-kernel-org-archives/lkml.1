Return-Path: <linux-kernel-owner+w=401wt.eu-S1755500AbYBEEQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbYBEEQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 23:16:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbYBEEQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 23:16:36 -0500
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:58177
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752059AbYBEEQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 23:16:36 -0500
X-Greylist: delayed 332 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Feb 2008 23:16:35 EST
Date: Mon, 4 Feb 2008 20:11:03 -0800
From: Phil Oester <kernel@linuxace.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 arch updates for v2.6.25
Message-ID: <20080205041103.GA11240@linuxace.com>
References: <20080130011550.GA31853@elte.hu> <200802050436.31070.maximlevitsky@gmail.com> <alpine.LFD.1.00.0802041922300.3237@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802041922300.3237@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 07:27:53PM -0800, Linus Torvalds wrote:
> kgdb? Not so interesting. We have many more hard problems happening at 
> user sites, not in developer hands.

FWIW, I'm not a fulltime developer by any means, but on occasion
I have fixed a few bugs in the netfilter area of the kernel.
And in almost all cases, I used kgdb in my debugging and testing
of fixes.  

In doing so, it was a bit of a PITA to find/patch kgdb into the
kernel, and having it as a configurable option would have saved
me some time and effort and made the process much smoother.

So perhaps someone else out there would find it similarly useful,
and the extra time it takes to find/patch/compile kgdb in is
precluding them from participating?  Why would we ever want to do
that?

Phil
