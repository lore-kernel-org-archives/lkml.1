Return-Path: <linux-kernel-owner+w=401wt.eu-S1755920AbYJNVIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbYJNVIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 17:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162AbYJNVIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 17:08:31 -0400
Received: from tservice.net.ru ([195.178.208.66]:35431 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097AbYJNVIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 17:08:30 -0400
Date: Wed, 15 Oct 2008 01:08:27 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Andreas Dilger <adilger@sun.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Distributed storage release.
Message-ID: <20081014210827.GA31312@2ka.mipt.ru>
References: <20081006160034.GA611@2ka.mipt.ru> <20081012192419.fd8394c9.akpm@linux-foundation.org> <20081013133850.GA13565@2ka.mipt.ru> <20081014155143.GM2009@webber.adilger.int> <20081014161256.GA22286@2ka.mipt.ru> <20081014203529.GW2009@webber.adilger.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081014203529.GW2009@webber.adilger.int>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 02:35:29PM -0600, Andreas Dilger (adilger@sun.com) wrote:
> > Like Scsi_Host and include/scsi/scsi_host.h? My favourite coding style
> > standards! It has the same space issues I have, but my code does not use
> > capital letters :)
> 
> I totally agree - this is a sign that in the past the kernel didn't follow
> the coding style closely enough and now we have a mishmash of code styles.
> That doesn't mean that new code should also contribute to that mess, but
> that old code should be cleaned up - as it is updated.

Ext4 is a very new code :)
There are several lines which exceed 80 columns, which are actually
comments, just what was blamed by the checkpatch.pl only. Really, no one
cares about them.

> > I always wondered... I submit almost 5 thousands line of code and I'm
> > blamed that I do not have or have too many spaces in several dozens of
> > lines. Should I get it as kernel hackers can not say anything bad about
> > project except amount of spaces?
> 
> I was only commenting about your refusal to change the code style when
> Andrew asked it of you.  There are good reasons to have a standard code
> style for large projects even if it isn't everyone's preferred style.

That's what I meant :) Actually all other signs from The God of
Checkpatch were sacrificed long ago, there are just several spaces
and braces: let them be a small group of heathens at this religion time.

Standards are great, but killing a child just because he or she is
left-hander, is a bit crazy, don't you think? So it would be quite
interesting to hear that (at least one) showstopper for inclusion
is a number of spaces :)

Of course this is stupid. Pointing to the ext4 with spaces is stupid.
Taking care about what no one ever cares and make that to be a
something significant is stupid. Making a religion out of checkpatch.pl
output is actually great. As great as counting number of steps to the
street corner and making that meaning of the life. Or at least a ground.

-- 
	Evgeniy Polyakov
