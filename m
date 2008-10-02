Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbYJBP65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbYJBP65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 11:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbYJBP6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 11:58:50 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:20803 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbYJBP6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 11:58:49 -0400
Date: Thu, 2 Oct 2008 08:58:20 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Steven Noonan" <steven@uplinklabs.net>
Cc: "Pavel Machek" <pavel@suse.cz>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>
Subject: Re: make MAINTAINERS slightly easier to search
Message-Id: <20081002085820.3568934d.randy.dunlap@oracle.com>
In-Reply-To: <f488382f0810020208u5761a84p5cac040503f55917@mail.gmail.com>
References: <20081002081428.GA2022@elf.ucw.cz>
	<f488382f0810020208u5761a84p5cac040503f55917@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008 02:08:20 -0700 Steven Noonan wrote:

> On Thu, Oct 2, 2008 at 1:14 AM, Pavel Machek <pavel@suse.cz> wrote:
> > ...shall we add rule that subsystems will have "subsystem" in the name
> > so that search does not list all the drivers, first?
> >
> > Signed-off-by: Pavel Machek <pavel@suse.cz>
> > Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
> >
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 3596d17..7345707 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -3825,7 +3825,7 @@ L:        linux-kernel@vger.kernel.org
> >  W:     http://tifmxx.berlios.de/
> >  S:     Maintained
> >
> > -SOUND
> > +SOUND SUBSYSTEM (ADVANCED LINUX SOUND SYSTEM, ALSA)
> 
> Advanced Linux Sound System = ALSS? How about switching it to
> 'ADVANCED LINUX SOUND ARCHITECTURE', which fits the original acronym?
> :)

Yes, concur.  Thanks.

> >  P:     Jaroslav Kysela
> >  M:     perex@perex.cz
> >  L:     alsa-devel@alsa-project.org (subscribers-only)
> > @@ -3855,7 +3855,7 @@ L:        cbe-oss-dev@ozlabs.org
> >  W:     http://www.ibm.com/developerworks/power/cell/
> >  S:     Supported
> >
> > -STABLE BRANCH:
> > +STABLE BRANCH
> >  P:     Greg Kroah-Hartman
> >  M:     greg@kroah.com
> >  P:     Chris Wright



---
~Randy
