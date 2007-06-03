Return-Path: <linux-kernel-owner+w=401wt.eu-S1763511AbXFCEQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763511AbXFCEQO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 00:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbXFCEP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 00:15:59 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35049 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751690AbXFCEP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 00:15:59 -0400
Date: Sat, 2 Jun 2007 21:15:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Scott Preece" <sepreece@gmail.com>, "Adrian Bunk" <bunk@stusta.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/1] document Acked-by:
Message-Id: <20070602211539.0224706b.akpm@linux-foundation.org>
In-Reply-To: <20070602210614.75862701.randy.dunlap@oracle.com>
References: <200706010209.l51299kN000531@shell0.pdx.osdl.net>
	<20070602141144.GC5500@stusta.de>
	<20070602104700.53b6b811.akpm@linux-foundation.org>
	<7b69d1470706021957t4d6a1b43k33c0766b27975f31@mail.gmail.com>
	<20070602210614.75862701.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Jun 2007 21:06:14 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Sat, 2 Jun 2007 19:57:41 -0700 Scott Preece wrote:
> 
> > On 6/2/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > ...
> > > +The Signed-off-by: tag implies that the signer was involved in the development
> > ---
> > 
> > Change "implies" to "indicates" - it's an explicit statement, not an
> > implication.
> > 
> > ---
> > > +of the patch, or that he/she was in the patch's delivery path.
> > > +
> > > +If a person was not directly involved in the preparation or handling of a
> > > +patch but wishes to signify and record their approval of it then they can
> > > +arrange to have an Acked-by: line added to the patch's changelog.
> > > +
> > > +Acked-by: is often used by the maintainer of the affected code when that
> > > +maintainer neither contributed to nor forwarded the patch themselves.
> > ---
> > 
> > This using plural pronouns for indefinite gender leaves one in vague
> > territory, but I think "themself" would be better than "themselves,
> > since "maintainer" is singular.
> 
> ugh.  :(
> not-acked-by: /me
> 

I just deleted it ;)

"neither contributed to nor forwarded the patch."
