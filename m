Return-Path: <linux-kernel-owner+w=401wt.eu-S1757745AbZKXCl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745AbZKXCl3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 21:41:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757599AbZKXCl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 21:41:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40197 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757584AbZKXCl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 21:41:27 -0500
Date: Mon, 23 Nov 2009 18:34:35 -0800
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 23
Message-ID: <20091124023435.GA22643@suse.de>
References: <20091123185232.1423c56b.sfr@canb.auug.org.au> <20091123111510.9b0c0714.randy.dunlap@oracle.com> <200911240924.54675.rusty@rustcorp.com.au> <20091124103318.bfcb504c.sfr@canb.auug.org.au> <20091123233843.GA13464@suse.de> <4B0B1DD2.9000404@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0B1DD2.9000404@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 03:42:10PM -0800, Randy Dunlap wrote:
> Greg KH wrote:
> > On Tue, Nov 24, 2009 at 10:33:18AM +1100, Stephen Rothwell wrote:
> >> Hi Rusty,
> >>
> >> On Tue, 24 Nov 2009 09:24:54 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:
> >>>     And I guess linux-next doesn't build staging?
> >> Correct - it breaks to much and too often :-)
> > 
> > Yes, remember, it's crap, you don't want to build it :)
> 
> that's certainly one way to look at it, but I do spend time/effort
> trying to get it to build, then send patches that either get dropped
> or sit in a queue or ignored for a long time by their driver writer,
> so you are just reinforcing the negativism associated with staging.
> 
> I don't think that's what you should be doing.

Yes, sometimes I do have a week or two lag in applying staging patches,
that is true.

But blame me for that, don't poke Stephen or others about the issue,
it's just me off stuck doing "real work".

If it wasn't for this pesky job I have, I'd be able to get lots of work
done :)

Anyway, I'll try to be more responsive, my appologies.

greg k-h
