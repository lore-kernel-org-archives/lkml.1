Return-Path: <linux-kernel-owner+w=401wt.eu-S1754984AbXJJAGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbXJJAGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 20:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbXJJAGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 20:06:32 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58333 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751489AbXJJAGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 20:06:32 -0400
Date: Wed, 10 Oct 2007 10:06:14 +1000
From: David Chinner <dgc@sgi.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Neil Brown <neilb@suse.de>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org
Subject: Re: RFC: reviewer's statement of oversight
Message-ID: <20071010000614.GA23367404@sgi.com>
References: <18186.50640.970552.719041@notabene.brown> <31862.1191948560@lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31862.1191948560@lwn.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 10:49:20AM -0600, Jonathan Corbet wrote:
> Neil Brown <neilb@suse.de> wrote:
> > > + (b) Any problems, concerns, or questions relating to the patch have been
> > > +     communicated back to the submitter.  I am satisfied with how the
> > > +     submitter has responded to my comments.
> > 
> > This seems more detailed that necessary.  The process (communicated
> > back / responded) is not really relevant.
> 
> Instead, it seems to me that the process is crucially important.
> Reviewed-by shouldn't be a rubber stamp that somebody applies to a
> patch; I think it should really imply that issues of interest have been
> communicated to the developers.  If we are setting expectations for what
> Reviewed-by means, I would prefer to leave an explicit mention of
> communication in there. 

I couldn't agree more, Jon.

If we are to have a meaningful reviewed-by tag, it has to be clearly
documented as to what responsibilities it places on the reviewer. If
someone doesn't want to perform a well conducted review, then they
haven't earned the right to issue a Reviewed-by tag - they can use
the Acked-by rubber stamp instead.

FWIW, w.r.t. XFS patches, we already follow both the letter and
intent of your proposed reviewed-by tag for all changes to XFS code
and reviewers are currently listed as Signed-off-by in git-commits
(our internal SCM records the reviewer(s) and the git export script
converts that to s-o-b).  It would be much more meaningful if they
were exported as Reviewed-by under your definition....

IOWs, I fully support your definition of the Reviewed-by tag.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
