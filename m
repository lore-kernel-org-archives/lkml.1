Return-Path: <linux-kernel-owner+w=401wt.eu-S1761816AbXE2DFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761816AbXE2DFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 23:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbXE2DFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 23:05:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:43146 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616AbXE2DFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 23:05:46 -0400
From: Neil Brown <neilb@suse.de>
To: Theodore Tso <tytso@mit.edu>
Date: Tue, 29 May 2007 13:05:29 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18011.39033.841231.377192@notabene.brown>
Cc: Pavel Machek <pavel@ucw.cz>,
       Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz>,
       Jesper Juhl <jesper.juhl@gmail.com>, linux-kernel@vger.kernel.org,
       ext3-users@redhat.com
Subject: Re: fs periodic check (was Re: 2.6.22-rc1 killed my ext3 filesystem cleanly unmounted)
In-Reply-To: message from Theodore Tso on Monday May 28
References: <20070518090604.GA10841@ribosome.natur.cuni.cz>
	<9a8748490705180720u3baf9785l910581a2a76a6eb@mail.gmail.com>
	<20070518143529.GB14611@ribosome.natur.cuni.cz>
	<20070518215731.GB10655@thunk.org>
	<20070520195526.GA5235@ucw.cz>
	<20070522180158.GA4668@thunk.org>
	<20070524173911.GA4541@ucw.cz>
	<20070529025534.GD24003@thunk.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday May 28, tytso@mit.edu wrote:
> On Thu, May 24, 2007 at 05:39:11PM +0000, Pavel Machek wrote:
> > Right. Could we get more helpful message here? 'Filesystem check on
> > next boot on AC power'? 
> 
> So "(check deferred; on battery)" wasn't explicit enough?  I guess I
> assumed that users would understand that the opposite of "on battery"
> was "on AC power".  I guess I could say "(check defferred 'til on AC
> power)" if people think it would be clearer.
> 

So when I use my travelling power adapter which I plug into the 12V-DC
power in my car, and it delivers DC power to my notebook.....
My note book tells me that I am using AC power....

I really think "AC" as the opposite of "battery" is wrong and should
be stamped out everywhere, certainly not introduced here.

"external power" maybe?

  Check deferred until system is externally powered.

NeilBrown
