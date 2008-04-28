Return-Path: <linux-kernel-owner+w=401wt.eu-S966765AbYD1VBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966765AbYD1VBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 17:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934949AbYD1VBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 17:01:16 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:51671 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934911AbYD1VBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 17:01:15 -0400
Date: Mon, 28 Apr 2008 15:01:13 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: [GIT PATCH] SCSI updates for 2.6.25
Message-ID: <20080428210112.GC14990@parisc-linux.org>
References: <1208540517.3063.18.camel@localhost.localdomain> <20080419151934.GA17089@elte.hu> <1208620484.3280.23.camel@localhost.localdomain> <20080419170530.GD1595@cs181133002.pp.htv.fi> <1208626496.3280.40.camel@localhost.localdomain> <alpine.LFD.1.10.0804191305360.2779@woody.linux-foundation.org> <20080419204511.GP20637@parisc-linux.org> <20080428210034.GE18248@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428210034.GE18248@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 11:00:34PM +0200, Sam Ravnborg wrote:
> On Sat, Apr 19, 2008 at 02:45:11PM -0600, Matthew Wilcox wrote:
> > On Sat, Apr 19, 2008 at 01:14:23PM -0700, Linus Torvalds wrote:
> > > So people: stop this total *idiocy* with "select is bad". It's not. The 
> > > lack of select is *much* worse.
> > 
> > Could we consider applying this patch then?
> 
> I applied the following.

Reads much better.  Thanks!

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
