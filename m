Return-Path: <linux-kernel-owner+w=401wt.eu-S1751363AbXFCSbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363AbXFCSbk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 14:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751090AbXFCSbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 14:31:33 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:4959 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbXFCSbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 14:31:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XsWpniYK3qtQ1YBe2MCxx2ODvivz2u2/LHrYRTs0TYhNcEpctuEPONEXIchWt7t2Y6eAcRSp/FReHWZltR7CHBiUazUrWXaezKHAXoprIz/s5GJ8qBT4x6bHiiTIDwpXE4g6QFEIlB8NLy7d0t9HRoeschwvnxdBwvFmeSTeUFw=
Message-ID: <7b69d1470706031131p768e9084jd594d02105095313@mail.gmail.com>
Date: Sun, 3 Jun 2007 13:31:30 -0500
From: "Scott Preece" <sepreece@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [patch 1/1] document Acked-by:
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>, "Adrian Bunk" <bunk@stusta.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070602211539.0224706b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706010209.l51299kN000531@shell0.pdx.osdl.net>
	 <20070602141144.GC5500@stusta.de>
	 <20070602104700.53b6b811.akpm@linux-foundation.org>
	 <7b69d1470706021957t4d6a1b43k33c0766b27975f31@mail.gmail.com>
	 <20070602210614.75862701.randy.dunlap@oracle.com>
	 <20070602211539.0224706b.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/2/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Sat, 2 Jun 2007 21:06:14 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:
>
> > On Sat, 2 Jun 2007 19:57:41 -0700 Scott Preece wrote:
> >
> > > On 6/2/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > ...
> > > > +The Signed-off-by: tag implies that the signer was involved in the development
> > > ---
> > >
> > > Change "implies" to "indicates" - it's an explicit statement, not an
> > > implication.
> > >
> > > ---
> > > > +of the patch, or that he/she was in the patch's delivery path.
> > > > +
> > > > +If a person was not directly involved in the preparation or handling of a
> > > > +patch but wishes to signify and record their approval of it then they can
> > > > +arrange to have an Acked-by: line added to the patch's changelog.
> > > > +
> > > > +Acked-by: is often used by the maintainer of the affected code when that
> > > > +maintainer neither contributed to nor forwarded the patch themselves.
> > > ---
> > >
> > > This using plural pronouns for indefinite gender leaves one in vague
> > > territory, but I think "themself" would be better than "themselves,
> > > since "maintainer" is singular.
> >
> > ugh.  :(
> > not-acked-by: /me
> >
>
> I just deleted it ;)
>
> "neither contributed to nor forwarded the patch."
>
---

Wise as usual - much better!

scott
