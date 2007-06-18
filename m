Return-Path: <linux-kernel-owner+w=401wt.eu-S1764880AbXFRUbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764880AbXFRUbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 16:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763626AbXFRUb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 16:31:27 -0400
Received: from THUNK.ORG ([69.25.196.29]:50068 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763572AbXFRUb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 16:31:26 -0400
Date: Mon, 18 Jun 2007 16:30:33 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jeremy Allison <jra@samba.org>
Cc: alan <alan@clueserver.org>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
Message-ID: <20070618203033.GD24189@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jeremy Allison <jra@samba.org>, alan <alan@clueserver.org>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Jack Stone <jack@hawkeye.stone.uk.eu.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	akpm@linux-foundation.org, viro@zeniv.linux.org.uk
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <467314E2.9010306@zytor.com> <Pine.LNX.4.64.0706151547200.27993@blackbox.fnordora.org> <20070616145337.GA13391@lazybastard.org> <20070618094524.GF5181@schatzie.adilger.int> <20070618140143.GD30244@thunk.org> <Pine.LNX.4.64.0706180907580.22137@blackbox.fnordora.org> <20070618172955.GB24189@thunk.org> <20070618173342.GB1152@samba1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618173342.GB1152@samba1>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 10:33:42AM -0700, Jeremy Allison wrote:
> 
> Yeah, ok - but do you have to rub my nose in it every chance you get ?
> 
> :-) :-).

Well, I just want to make sure people know that Samba isn't asking for
it any more, and I don't know of any current requests outstanding from
any of the userspace projects.  So there's no one we need to ship off
to the re-education camps about why filesystem fork/streams are a bad
idea.  :-)

						- Ted
