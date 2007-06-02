Return-Path: <linux-kernel-owner+w=401wt.eu-S1762612AbXFBRSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762612AbXFBRSn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 13:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760687AbXFBRSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 13:18:37 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:58789 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760612AbXFBRSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 13:18:36 -0400
Date: Sat, 2 Jun 2007 19:17:46 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Dave Jones <davej@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/1] document Acked-by:
In-Reply-To: <20070601182835.GC16529@redhat.com>
Message-ID: <Pine.LNX.4.61.0706021916000.5076@yvahk01.tjqt.qr>
References: <200706010209.l51299kN000531@shell0.pdx.osdl.net>
 <20070601181414.GC7968@redhat.com> <20070601112225.80a8be84.akpm@linux-foundation.org>
 <20070601182835.GC16529@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 1 2007 14:28, Dave Jones wrote:
> > > On Thu, May 31, 2007 at 07:09:10PM -0700, Andrew Morton wrote:
> > >  > From: Andrew Morton <akpm@linux-foundation.org>
> > >  > 
> > >  > Explain what we use Acked-by: for, and how it differs from Signed-off-by:
> > >  > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > >  > +
> > >  > +If a person was not directly involved in the preparation or handling of a
> > >  > +patch but wishes to signify and record their approval of it then they can
> > >  > +arrange to have an Acked-by: line added to the patch's changelog.
> > > 
> > > Acked-by: Dave Jones <davej@redhat.com>
> > 
> > What, no Tested-by: ?
>
>Heh. Indeed.  I think there's room for both fwiw.

Too verbose. Suggest a typedef.

	Signed-off-and-tested-by: Foo J. Bar <addy@corps>


	Jan
-- 
