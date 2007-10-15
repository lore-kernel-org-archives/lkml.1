Return-Path: <linux-kernel-owner+w=401wt.eu-S1763687AbXJOA10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763687AbXJOA10 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 20:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbXJOA1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 20:27:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:50555 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbXJOA1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 20:27:16 -0400
From: Neil Brown <neilb@suse.de>
To: David Chinner <dgc@sgi.com>
Date: Mon, 15 Oct 2007 10:27:08 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18194.46044.601552.537774@notabene.brown>
Cc: Jonathan Corbet <corbet@lwn.net>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org
Subject: Re: RFC: reviewer's statement of oversight
In-Reply-To: message from David Chinner on Wednesday October 10
References: <18186.50640.970552.719041@notabene.brown>
	<31862.1191948560@lwn.net>
	<20071010000614.GA23367404@sgi.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday October 10, dgc@sgi.com wrote:
> On Tue, Oct 09, 2007 at 10:49:20AM -0600, Jonathan Corbet wrote:
> > Neil Brown <neilb@suse.de> wrote:
> > > > + (b) Any problems, concerns, or questions relating to the patch have been
> > > > +     communicated back to the submitter.  I am satisfied with how the
> > > > +     submitter has responded to my comments.
> > > 
> > > This seems more detailed that necessary.  The process (communicated
> > > back / responded) is not really relevant.
> > 
> > Instead, it seems to me that the process is crucially important.
> > Reviewed-by shouldn't be a rubber stamp that somebody applies to a
> > patch; I think it should really imply that issues of interest have been
> > communicated to the developers.  If we are setting expectations for what
> > Reviewed-by means, I would prefer to leave an explicit mention of
> > communication in there. 
> 
> I couldn't agree more, Jon.
> 
> If we are to have a meaningful reviewed-by tag, it has to be clearly
> documented as to what responsibilities it places on the reviewer. If
> someone doesn't want to perform a well conducted review, then they
> haven't earned the right to issue a Reviewed-by tag - they can use
> the Acked-by rubber stamp instead.

Maybe I'm making a mountain out of a molehill but...

Clearly documented responsibilities?  Yes.
Prescribed process?  No.

If someone sends me a patch, and I review it, and I find a couple of
problems, do I need to negotiate with the submitter before correcting
them and putting a "Reviewed-by" tag on it (along with my
Signed-off-by before sending it upstream)?

The above clause (b) seems to say that I do.  Is that something we
want to mandate?

My take on the responsibilities implied by Reviewed-by: is that the
code has been inspected, comprehended, considered, and found to be
both appropriate and without discernible error.  The process by which
the code got to that state is not relevant to the tag (though it
probably is relevant to the general health of the community).

NeilBrown
