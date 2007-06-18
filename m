Return-Path: <linux-kernel-owner+w=401wt.eu-S1762470AbXFRRzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762470AbXFRRzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 13:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759091AbXFRRzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 13:55:39 -0400
Received: from mail.samba.org ([66.70.73.150]:49020 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757187AbXFRRzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 13:55:38 -0400
X-Greylist: delayed 1273 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Jun 2007 13:55:38 EDT
Date: Mon, 18 Jun 2007 10:33:42 -0700
From: Jeremy Allison <jra@samba.org>
To: Theodore Tso <tytso@mit.edu>, alan <alan@clueserver.org>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
Message-ID: <20070618173342.GB1152@samba1>
Reply-To: Jeremy Allison <jra@samba.org>
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <467314E2.9010306@zytor.com> <Pine.LNX.4.64.0706151547200.27993@blackbox.fnordora.org> <20070616145337.GA13391@lazybastard.org> <20070618094524.GF5181@schatzie.adilger.int> <20070618140143.GD30244@thunk.org> <Pine.LNX.4.64.0706180907580.22137@blackbox.fnordora.org> <20070618172955.GB24189@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618172955.GB24189@thunk.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 01:29:56PM -0400, Theodore Tso wrote:
> On Mon, Jun 18, 2007 at 09:16:30AM -0700, alan wrote:
> > 
> > I just wish that people would learn from the mistakes of others.  The 
> > MacOS is a prime example of why you do not want to use a forked 
> > filesystem, yet some people still seem to think it is a good idea. 
> > (Forked filesystems tend to be fragile and do not play well with 
> > non-forked filesystems.)
> 
> Jeremy Alison used to be the one who was always pestering me to add
> Streams support into ext4, but recently he's admitted that I was right
> that it was a Very Bad Idea.

Yeah, ok - but do you have to rub my nose in it every chance you get ?

:-) :-).

Jeremy.
