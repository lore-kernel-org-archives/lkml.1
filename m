Return-Path: <linux-kernel-owner+w=401wt.eu-S1757532AbXI3D2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbXI3D2q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 23:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbXI3D2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 23:28:40 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36444 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbXI3D2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 23:28:39 -0400
Date: Sat, 29 Sep 2007 23:28:18 -0400
Message-Id: <200709300328.l8U3SIl3022352@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Theodore Tso <tytso@mit.edu>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Erez Zadok <ezk@cs.sunysb.edu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 0/3 coding standards documentation/code updates 
In-reply-to: Your message of "Sat, 29 Sep 2007 22:06:37 EDT."
             <20070930020637.GA29996@thunk.org> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20070930020637.GA29996@thunk.org>, Theodore Tso writes:
> On Sat, Sep 29, 2007 at 03:56:38PM -0400, J. Bruce Fields wrote:
> > It'd be a start just to revert CodingStyle to its original content and
> > move the rest to CodingStyleReference.  But someone would want to skim
> > through the CodingStyle history for any legimate corrections that we
> > want to keep.
> 
> How about CodingStyleSuggestions?  And let's make it clear they are
> suggestions, and not things that checkpatch should be flaming about
> unless people request the all of the annoying associated false
> positives via --spam-me-harder.  :-)

FWIW, the checkpatch script is woefully out of sync with CodingStyle.  I
assume that checkpatch.pl is generally more authoritative (sans "(%d)" :-)

>        	      	      	       			  - Ted

Erez.
