Return-Path: <linux-kernel-owner+w=401wt.eu-S1761249AbXEMXaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761249AbXEMXaW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 19:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756760AbXEMXaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 19:30:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758131AbXEMXaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 19:30:09 -0400
Date: Sun, 13 May 2007 19:29:53 -0400
From: Dave Jones <davej@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Riley@Williams.Name
Subject: Re: MAINTAINERS update.
Message-ID: <20070513232953.GJ27604@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>, Riley@Williams.Name
References: <20070513230746.GA3607@redhat.com> <46479AFC.7020404@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46479AFC.7020404@zytor.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2007 at 04:10:52PM -0700, H. Peter Anvin wrote:
 > Dave Jones wrote:
 > > I've not really 'maintained' this code for years, and others
 > > are doing a much more thorough job these days.
 > > Removing myself might stem some of the crazier emails I get.
 > > 
 > > Signed-off-by: Dave Jones <davej@redhat.com>
 > > 
 > > diff --git a/MAINTAINERS b/MAINTAINERS
 > > index 68a56ad..21f3fff 100644
 > > --- a/MAINTAINERS
 > > +++ b/MAINTAINERS
 > > @@ -1712,8 +1712,6 @@ L:	Linux-Kernel@vger.kernel.org
 > >  S:	Maintained
 > >  
 > >  i386 SETUP CODE / CPU ERRATA WORKAROUNDS
 > > -P:	Dave Jones
 > > -M:	davej@codemonkey.org.uk
 > >  P:	H. Peter Anvin
 > >  M:	hpa@zytor.com
 > >  S:	Maintained
 > 
 > To the extent needed...
 > 
 > Acked-by: H. Peter Anvin <hpa@zytor.com>

That previous entry of MAINTAINERS raised an eyebrow too.
You, Eric, Andi, and Zach seem to have done more work on 'i386 BOOT CODE'
in the last few months than I recall Riley doing, well.. since ages.
Not to belittle whatever work he did, but perhaps his entry belongs
more in CREDITS than MAINTAINERS.  It felt a little cheeky to be
messing with someone elses entry though.  Riley?

Perhaps those two entries should just be merged together to become
"i386 Architecture" too ?

	Dave

-- 
http://www.codemonkey.org.uk
