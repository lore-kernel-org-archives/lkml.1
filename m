Return-Path: <linux-kernel-owner+w=401wt.eu-S1756161AbXJIQtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbXJIQtc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 12:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755606AbXJIQtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 12:49:23 -0400
Received: from vena.lwn.net ([206.168.112.25]:45272 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755632AbXJIQtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 12:49:22 -0400
To: Neil Brown <neilb@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: RFC: reviewer's statement of oversight 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Tue, 09 Oct 2007 10:05:36 +1000."
             <18186.50640.970552.719041@notabene.brown> 
Date: Tue, 09 Oct 2007 10:49:20 -0600
Message-ID: <31862.1191948560@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown <neilb@suse.de> wrote:

> I find it is always good to know *why* we have the tags.  That
> information is a useful complement to what they mean, and can guide
> people in adding them.

Hmm...I was just going to go with the "because I told you so" approach
that I use with my kids.  It works so well with them after all.  

<pauses to go scream at his kids who have never understood why playing
"Dance Dance Revolution" directly above the office is hard on
productivity> 

I agree with just about everything you've said, and am tweaking things
accordingly.  But...

> > + (b) Any problems, concerns, or questions relating to the patch have been
> > +     communicated back to the submitter.  I am satisfied with how the
> > +     submitter has responded to my comments.
> 
> This seems more detailed that necessary.  The process (communicated
> back / responded) is not really relevant.

Instead, it seems to me that the process is crucially important.
Reviewed-by shouldn't be a rubber stamp that somebody applies to a
patch; I think it should really imply that issues of interest have been
communicated to the developers.  If we are setting expectations for what
Reviewed-by means, I would prefer to leave an explicit mention of
communication in there.  If I'm in the minority here, though, it can
certainly come out.

Thanks,

jon

