Return-Path: <linux-kernel-owner+w=401wt.eu-S1755216AbXI3CG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbXI3CG6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 22:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbXI3CGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 22:06:51 -0400
Received: from thunk.org ([69.25.196.29]:38179 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273AbXI3CGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 22:06:50 -0400
Date: Sat, 29 Sep 2007 22:06:37 -0400
From: Theodore Tso <tytso@mit.edu>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Erez Zadok <ezk@cs.sunysb.edu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 0/3 coding standards documentation/code updates
Message-ID: <20070930020637.GA29996@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Erez Zadok <ezk@cs.sunysb.edu>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <11910151223214-git-send-email-ezk@cs.sunysb.edu> <alpine.LFD.0.999.0709291116180.3579@woody.linux-foundation.org> <20070929195638.GA12011@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070929195638.GA12011@fieldses.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 29, 2007 at 03:56:38PM -0400, J. Bruce Fields wrote:
> It'd be a start just to revert CodingStyle to its original content and
> move the rest to CodingStyleReference.  But someone would want to skim
> through the CodingStyle history for any legimate corrections that we
> want to keep.

How about CodingStyleSuggestions?  And let's make it clear they are
suggestions, and not things that checkpatch should be flaming about
unless people request the all of the annoying associated false
positives via --spam-me-harder.  :-)

       	      	      	       			  - Ted
