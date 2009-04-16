Return-Path: <linux-kernel-owner+w=401wt.eu-S1758453AbZDPQjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758453AbZDPQjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 12:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757224AbZDPQir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 12:38:47 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:40531 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758009AbZDPQip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 12:38:45 -0400
Date: Thu, 16 Apr 2009 18:40:50 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>, takata@linux-m32r.org,
       linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Re: last remaining asm/ header moves: h8300 and m32r
Message-ID: <20090416164050.GB4850@uranus.ravnborg.org>
References: <20090416150707.GA941@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090416150707.GA941@lst.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 05:07:07PM +0200, Christoph Hellwig wrote:
> Hello,
> 
> h8300 and m32r are the last two architectures still having their asm/
> headers in include/ instead of arch/$arch/include.  Any chance you could
> do the move for 2.6.30 so we're only left with one way of doing it?

h8300 only have one file let in asm-h8300 by mistake.
I got OK to send a patch for this so will do so tonight.

And I also pinged privately for m32r - and I recall I did so in the past too.
If I see no response real soon I will just ask Linus
to do the move as it is straightforward.

	Sam
