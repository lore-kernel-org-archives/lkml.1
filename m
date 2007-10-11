Return-Path: <linux-kernel-owner+w=401wt.eu-S1758234AbXJKVVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234AbXJKVVI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 17:21:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754721AbXJKVU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 17:20:57 -0400
Received: from thunk.org ([69.25.196.29]:36492 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754954AbXJKVU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 17:20:56 -0400
Date: Thu, 11 Oct 2007 17:20:50 -0400
From: Theodore Tso <tytso@mit.edu>
To: David Schwartz <davids@webmaster.com>
Cc: "Crane, Matthew" <mcrane03@harris.com>, linux-kernel@vger.kernel.org
Subject: Re: Aggregation in embedded context, is kernel GPL2
	prejudiceagainst embedded systems?
Message-ID: <20071011212049.GL10759@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	David Schwartz <davids@webmaster.com>,
	"Crane, Matthew" <mcrane03@harris.com>,
	linux-kernel@vger.kernel.org
References: <20071011151543.GX16424@stusta.de> <MDEHLPKNGKAHNMBLJOLKAEHKHGAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKAEHKHGAC.davids@webmaster.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2007 at 01:49:03PM -0700, David Schwartz wrote:
> Adrian Bunk wrote:
> 
> > even for dynamically linking including non-GPL code is not white but 
> > already dark grey.
> 
> IANAL, but personally, I think it's perfectly black and white.
> 
> No mechanical combination (that means compressing, linking, tarring,
> compiling, or whatever) can create a work for copyright purposes. It
> can only convert the original work into a new form or aggregate
> works.
> 
> There are a few exceptions to this by statute. For example,
> translation (by explicit law) can create a derivative
> work. Presumably this was because nobody ever imagined an automated
> process that could translate a work. It was assumed such a process
> must always be creative.
> 
> To create a 'derivative work', you must create a new *work*, and a
> compiler and linker can't do that. Under copyright law, the creation
> of a work requires creative input. Compilers and linkers are not
> creative.

This may (or may not) be true in the US.  But whether or not it is
true in another legal jurisdiction, or whether there is code in the
form of inline functions in header files getting dragged in at
compilation time (and thus forming part of the driver object file),
are all reasons why the only valid answer is TALK TO A LAWYER, NOT
LKML.

						- Ted
