Return-Path: <linux-kernel-owner+w=401wt.eu-S1757320AbYDCUiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320AbYDCUiB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 16:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755275AbYDCUhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 16:37:52 -0400
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:60722 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248AbYDCUhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 16:37:51 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Apr 2008 16:37:51 EDT
Message-ID: <47F53E84.8080607@freedesktop.org>
Date: Thu, 03 Apr 2008 13:31:00 -0700
From: Josh Triplett <josh@freedesktop.org>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-sparse@vger.kernel.org
Subject: Re: [PATCH 7/7] asm-generic: suppress sparse warning in ioctl.h
References: <1207182818.5740.26.camel@brick> <alpine.LFD.1.00.0804021752040.14670@woody.linux-foundation.org> <20080403013420.GV9785@ZenIV.linux.org.uk> <alpine.LFD.1.00.0804021848140.14670@woody.linux-foundation.org> <20080403024117.GZ9785@ZenIV.linux.org.uk>
In-Reply-To: <20080403024117.GZ9785@ZenIV.linux.org.uk>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Wed, Apr 02, 2008 at 06:50:20PM -0700, Linus Torvalds wrote:
>>> BTW, what happened with sparse.git?
>> Yeah, we do seem to have lost a maintainer.
> 
> Have we?  I've seen Josh on sparse list quite recently, IIRC...
> Yes - http://marc.info/?l=linux-sparse&m=120716477203477 just
> yesterday...
> 
> Josh, do you have any pending patches?  I can just start a branch in
> my tree, of course, but I'd rather deal with merge headache earlier
> than later...

Starting around the beginning of this year, I got buried under
research temporarily in the Winter term, along with a couple of other
things.  I got caught up, and then proceeded to get sick for a week,
and that and recovery time put me far enough behind on both email and
research that I didn't catch up again until recently.

I mostly kept up with Sparse email, hence the recent mails, but built
up a backlog of patches to deal with.  (Sparse has a fairly low patch
rate, so that backlog constitutes less than 10 patches, counting the
ones that still need further work or discussion before they can
merge.)  Also, in switching my email to an IMAP server, I managed to
lose the read/unread status on some of my list mail, including
linux-sparse, which slowed me down a fair bit when trying to process
those mails.

I have a small handful of pending patches to work through on
linux-sparse, with yours at the top of that list; I also have some
local patches that I need to test and push.  Apologies for the
processing delay.

I should have thought to send a "still alive" note with an explanation
to linux-sparse.  I'll make sure to do so in the future.  (Some time
in the next couple of years I have a thesis to write. :) )

I'll catch the backlog up and then send out an "all patches merged"
mail, so that anyone with additional patches or anyone who thinks
their patch got lost can resend.

- Josh Triplett
