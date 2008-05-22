Return-Path: <linux-kernel-owner+w=401wt.eu-S933767AbYEVBMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933767AbYEVBMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 21:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758543AbYEVBMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 21:12:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757744AbYEVBMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 21:12:03 -0400
Date: Wed, 21 May 2008 18:10:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, andi@firstfloor.org,
       yhlu.kernel@gmail.com, ralf@linux-mips.org, rth@twiddle.net,
       rmk@arm.linux.org.uk, tony.luck@intel.com, takata@linux-m32r.org,
       geert@linux-m68k.org, kyle@parisc-linux.org, paulus@samba.org,
       lethal@linux-sh.org, davem@davemloft.net
Subject: Re: [RFC 0/3] bootmem rewrite
Message-Id: <20080521181005.6af9474a.akpm@linux-foundation.org>
In-Reply-To: <87hccr2n4m.fsf@saeurebad.de>
References: <20080521013735.559724194@saeurebad.de>
	<20080521165735.10c500dc.akpm@linux-foundation.org>
	<87hccr2n4m.fsf@saeurebad.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008 02:33:45 +0200 Johannes Weiner <hannes@saeurebad.de> wrote:

> > Anyway, if you can redo these patches against most-recent-mm or,
> > better, against http://userweb.kernel.org/~akpm/mmotm then it would
> > make things easier for me to handle.  I can then at least test it all
> > on my seven-odd test boxes.  Please feel free to ping me if you want a
> > single rolled-up patch - that's always trivial and I can do it in three
> > minutes.
> 
> I guess I just apply the quilt series to the tree you forked off?

yup.  http://userweb.kernel.org/~akpm/mmotm/mmotm-readme.txt

> > Finally, if you haven't done so, I'd encourage you to stuff as many
> > handy debugging printks into this code as you possibly can.  Just fill
> > 'er up with them.  So that when people start running it and it goes
> > boom, they can send you their debug output _without_ having to go
> > through another handful of email-email-patch-rebuild-retest cycles.  We
> > can pull them all out later on.
> 
> Okay, I will make it gossip and send you a -mmotm-based version of it.

Good luck :)
