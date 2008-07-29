Return-Path: <linux-kernel-owner+w=401wt.eu-S1758549AbYG2MFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549AbYG2MFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 08:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756250AbYG2MFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 08:05:08 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:48996 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756137AbYG2MFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 08:05:07 -0400
Date: Tue, 29 Jul 2008 08:04:42 -0400
From: Theodore Tso <tytso@MIT.EDU>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Alistair John Strachan <alistair@devzero.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dsd@gentoo.org, kune@deine-taler.de, linux-wireless@vger.kernel.org
Subject: Re: 2.6.27-rc1: zd1211rw association fails
Message-ID: <20080729120442.GE9378@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Johannes Berg <johannes@sipsolutions.net>,
	Alistair John Strachan <alistair@devzero.co.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dsd@gentoo.org, kune@deine-taler.de, linux-wireless@vger.kernel.org
References: <alpine.LFD.1.10.0807281956030.3334@nehalem.linux-foundation.org> <200807291049.47342.alistair@devzero.co.uk> <1217326195.10489.10.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217326195.10489.10.camel@johannes.berg>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 12:09:55PM +0200, Johannes Berg wrote:
> This is about the 100 millionth time this is reported. Please try the
> patch I just posted.

Yeah, it's really too bad -rc1 got released just before you were able
to post the fix to this, since if there were 100 million people who
were trying out kernels starting with -git7 that use wireless, there
will probably be 200 million people trying out -rc1.  :-)

Thanks for finding and fixing it, though.  I stopped trying out
kernels after -git6 since I was travelling at OSCON, and not having
wireless was a show-stopper for me....

						- Ted
