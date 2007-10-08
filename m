Return-Path: <linux-kernel-owner+w=401wt.eu-S1754595AbXJHVjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbXJHVjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 17:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbXJHVjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 17:39:13 -0400
Received: from THUNK.ORG ([69.25.196.29]:59421 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbXJHVjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 17:39:12 -0400
Date: Mon, 8 Oct 2007 17:38:52 -0400
From: Theodore Tso <tytso@mit.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, Sam Ravnborg <sam@ravnborg.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: RFC: reviewer's statement of oversight
Message-ID: <20071008213852.GA31713@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Jan Engelhardt <jengelh@computergmbh.de>,
	Sam Ravnborg <sam@ravnborg.org>, Jonathan Corbet <corbet@lwn.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Pekka Enberg <penberg@cs.helsinki.fi>
References: <25555.1191864285@lwn.net> <20071008173706.GA12026@uranus.ravnborg.org> <Pine.LNX.4.64.0710081939120.10239@fbirervta.pbzchgretzou.qr> <470A9422.4050400@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470A9422.4050400@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2007 at 01:33:38PM -0700, H. Peter Anvin wrote:
> Uhm, no.  There is no reason an "unimportant" person couldn't review a 
> patch, and therefore perform a potentially highly valuable service to 
> the maintainer.
> 
> None of these are indicative of the authority of the person acking, 
> reviewing, testing, or nacking.  That's only as good as the trust in the 
> person signing.

I would tend to agree.  Right now I think the problem is that we are
getting too little reviews, not enough.  And someone who reviews
patches, even if unknown, could be building up expertise that
eventually would make them a valued developer, even while they are
doing us a service.   

The concern that I suspect some people have is what if this gets
abused by people who don't really bother to do a full review of a
patch before they ack it.  We could ask reviewers to include a URL to
an LKML archive of their review, to make it easier to find a review of
a patch so later on people can judge how effective they their review
was.  Unfortunately, this would be an added burden for the regular
reviewers, so I doubt this would be well accepted as a practice.  My
suggestion is to not worry about this for now, and see how well it
works out in practice.  If we start getting half a dozen or more
Reviewed-by: where the patch is pretty clearly not getting adequately
reviewed, or where someone is obviously abusing the system, and social
pressures aren't working, we can try to figure out then how we want to
address that problem then.  Let's not make the process too complicated
unless we know it's necessary.  Premature complexity is almost as bad
as premature optimization....

					- Ted
