Return-Path: <linux-kernel-owner+w=401wt.eu-S1758881AbXFAKxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758881AbXFAKxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 06:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753737AbXFAKxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 06:53:12 -0400
Received: from hammerhead.shentel.net ([204.111.1.228]:54043 "EHLO
	hammerhead.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbXFAKxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 06:53:11 -0400
Date: Fri, 1 Jun 2007 06:53:06 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Valdis.Kletnieks@vt.edu, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/1] document Acked-by:
In-Reply-To: <465FB862.207@zytor.com>
Message-ID: <alpine.DEB.0.99.0706010648030.9768@sigma.j-a-k-j.com>
References: <200706010209.l51299kN000531@shell0.pdx.osdl.net>
 <28278.1180675923@turing-police.cc.vt.edu> <465FB862.207@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >> +If a person was not directly involved in the preparation or handling of a
> >> +patch but wishes to signify and record their approval of it then they can
> >> +arrange to have an Acked-by: line added to the patch's changelog.
> >> +
> >> +Acked-by: is often used by the maintainer of the affected code when that
> >> +maintainer neither wrote, merged nor forwarded the patch themselves.
> > 
> > Do we want to add verbiage saying that an Acked-By: is also useful when it
> > comes from somebody (likely the original reporter) who has actually tested the
> > patch?
> 
> I'd rather see a Tested-By: for that.
> 
> There is a difference between a maintainer ack and a tester ok.

Indeed. Acked-by: implies authority, and only very few people should be 
able to do it. Namely, the only person who can ACK a patch is a person who 
could also NACK a patch and expect it to actually be dropped. If I think a 
patch is bad, I can say so, but as I have no authority, my statement would 
be taken on merit alone, whereas Linus or Andrew or such could just NACK 
it and move on without having to spew a blurb every time.
