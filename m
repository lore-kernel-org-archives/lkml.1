Return-Path: <linux-kernel-owner+w=401wt.eu-S1755179AbXJHWDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbXJHWDk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 18:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbXJHWDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 18:03:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59577 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbXJHWDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 18:03:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Theodore Tso <tytso@mit.edu>
Subject: Re: RFC: reviewer's statement of oversight
Date: Tue, 9 Oct 2007 00:18:39 +0200
User-Agent: KMail/1.9.5
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jan Engelhardt <jengelh@computergmbh.de>,
       Sam Ravnborg <sam@ravnborg.org>, Jonathan Corbet <corbet@lwn.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
References: <25555.1191864285@lwn.net> <470A9422.4050400@zytor.com> <20071008213852.GA31713@thunk.org>
In-Reply-To: <20071008213852.GA31713@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710090018.40061.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 8 October 2007 23:38, Theodore Tso wrote:
> On Mon, Oct 08, 2007 at 01:33:38PM -0700, H. Peter Anvin wrote:
> > Uhm, no.  There is no reason an "unimportant" person couldn't review a 
> > patch, and therefore perform a potentially highly valuable service to 
> > the maintainer.
> > 
> > None of these are indicative of the authority of the person acking, 
> > reviewing, testing, or nacking.  That's only as good as the trust in the 
> > person signing.
> 
> I would tend to agree.  Right now I think the problem is that we are
> getting too little reviews, not enough.  And someone who reviews
> patches, even if unknown, could be building up expertise that
> eventually would make them a valued developer, even while they are
> doing us a service.   
> 
> The concern that I suspect some people have is what if this gets
> abused by people who don't really bother to do a full review of a
> patch before they ack it.  We could ask reviewers to include a URL to
> an LKML archive of their review, to make it easier to find a review of
> a patch so later on people can judge how effective they their review
> was.  Unfortunately, this would be an added burden for the regular
> reviewers, so I doubt this would be well accepted as a practice.  My
> suggestion is to not worry about this for now, and see how well it
> works out in practice.  If we start getting half a dozen or more
> Reviewed-by: where the patch is pretty clearly not getting adequately
> reviewed, or where someone is obviously abusing the system, and social
> pressures aren't working, we can try to figure out then how we want to
> address that problem then.  Let's not make the process too complicated
> unless we know it's necessary.  Premature complexity is almost as bad
> as premature optimization....

I agree.

Greetings,
Rafael
