Return-Path: <linux-kernel-owner+w=401wt.eu-S964923AbXBLNqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964923AbXBLNqG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 08:46:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964918AbXBLNqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 08:46:05 -0500
Received: from tim.rpsys.net ([194.106.48.114]:41394 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964919AbXBLNqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 08:46:04 -0500
Subject: Re: git backlight tree
From: Richard Purdie <rpurdie@rpsys.net>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, jsimmons@infradead.org,
       linux-kernel@hansmi.ch, openembedded@hrw.one.pl,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <200702102345.39855.lenb@kernel.org>
References: <1171153985.5836.66.camel@localhost.localdomain>
	 <200702102345.39855.lenb@kernel.org>
Content-Type: text/plain
Date: Mon, 12 Feb 2007 13:43:27 +0000
Message-Id: <1171287807.5898.122.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-02-10 at 23:45 -0500, Len Brown wrote:
> On Saturday 10 February 2007 19:33, Richard Purdie wrote:
> > As mentioned previously, I've setup a backlight git tree at:
> > 
> > http://git.o-hand.com/?p=linux-rpurdie-backlight;a=shortlog;h=for-mm
> > (git://git.o-hand.com/linux-rpurdie-backlight)
> > 
> > A patch of the combined changes to mainline is:
> > 
> > http://www.rpsys.net/openzaurus/patches/git_backlight-r1.patch.gz
> 
> The changes under drivers/acpi/ and drivers/misc/ look fine to me.
> Acked-by: Len Brown <len.brown@intel.com>
> if you need that to send those bits upstream.
> 
> Note that there is a new sony-laptop driver under drivers/misc/ in my tree
> that I expect to send upstream next week -- and it will need
> the analogous updates.

I'd noticed it and had sent Andrew a patch to keep things happy in -mm.
Now I know the timescales, I'll wait until after its gone in and fixup
the backlight tree accordingly before submitting.

Thanks,

Richard

