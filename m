Return-Path: <linux-kernel-owner+w=401wt.eu-S1758749AbXJKVK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749AbXJKVK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 17:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755607AbXJKVKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 17:10:51 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:24760 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599AbXJKVKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 17:10:50 -0400
Date: Thu, 11 Oct 2007 14:07:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Documentation/patch-tags v3
Message-Id: <20071011140740.8cce9970.randy.dunlap@oracle.com>
In-Reply-To: <1192135811.7899.25.camel@heimdal.trondhjem.org>
References: <30616.1192133818@lwn.net>
	<1192135811.7899.25.camel@heimdal.trondhjem.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2007 16:50:11 -0400 Trond Myklebust wrote:

> 
> On Thu, 2007-10-11 at 14:16 -0600, Jonathan Corbet wrote:
> > +----
> > +
> > +Reviewer's statement of oversight
> > +
> > +By offering my Reviewed-by: tag, I state that:
> > +
> > + (a) I have carried out a technical review of this patch to evaluate its
> > +     appropriateness and readiness for inclusion into the mainline kernel. 
> > +
> > + (b) Any problems, concerns, or questions relating to the patch have been
> > +     communicated back to the submitter.  I am satisfied with the
> > +     submitter's response to my comments.
> > +
> > + (c) While there may be things that could be improved with this submission,
> > +     I believe that it is, at this time, (1) a worthwhile modification to
> > +     the kernel, and (2) free of known issues which would argue against its
> > +     inclusion.
> > +
> > + (d) While I have reviewed the patch and believe it to be sound, I do not
> > +     (unless explicitly stated elsewhere) make any warranties or guarantees
> > +     that it will achieve its stated purpose or function properly in any
> > +     given situation.
> 
> I'm confused about how to reconcile (c) and (d) here. If you are not
> sure about whether or not the patch will achieve its stated purpose, why
> would you be arguing that it is a worthwhile modification?

Well, any non-trivial patch could have a lurking bug in it, even if
most code paths are tested.


I thought that I once saw (read) something like this:

Someone who gives a Reviewed-by: tag also is willing to take
ownership (or at least help debug) any problems that arise from the
patch, including but not limited to patch-author hit-by-bus conditions.

Did I dream that?

---
~Randy
