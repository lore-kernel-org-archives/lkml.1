Return-Path: <linux-kernel-owner+w=401wt.eu-S1757152AbZFXM0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152AbZFXM0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 08:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbZFXM0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 08:26:03 -0400
Received: from cantor.suse.de ([195.135.220.2]:48889 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbZFXM0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 08:26:02 -0400
Date: Wed, 24 Jun 2009 14:26:00 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Doug Thompson <norsk5@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ranganathan Desikan <rdesikan@jetzbroadband.com>,
       bluesmoke-devel@lists.sourceforge.net
Subject: Re: [PATCH] MAINTAINERS: pair names/addresses in EDAC-I82975X
In-Reply-To: <589165.9933.qm@web50102.mail.re2.yahoo.com>
Message-ID: <alpine.LRH.2.00.0906241425510.31685@twin.jikos.cz>
References: <589165.9933.qm@web50102.mail.re2.yahoo.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1747641777-1842657311-1245844424=:31685"
Content-ID: <alpine.LRH.2.00.0906241424410.31685@twin.jikos.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1747641777-1842657311-1245844424=:31685
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LRH.2.00.0906241424411.31685@twin.jikos.cz>

On Tue, 23 Jun 2009, Doug Thompson wrote:

> > From: Joe Perches <joe@perches.com>
> > Subject: [PATCH] MAINTAINERS: pair names/addresses in EDAC-I82975X
> > To: "LKML" <linux-kernel@vger.kernel.org>
> > Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ranganathan Desikan" <rdesikan@jetzbroadband.com>, "Arvind R." <arvind@acarlab.com>, bluesmoke-devel@lists.sourceforge.net
> > Date: Thursday, June 18, 2009, 12:54 PM
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> Signed-off-by: Doug Thompson <dougthompson@xmission.com>
> 
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index fb94add..e139389 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -2052,8 +2052,8 @@ F:   
> > drivers/edac/i5400_edac.c
> >  
> >  EDAC-I82975X
> >  P:    Ranganathan Desikan
> > -P:    Arvind R.
> >  M:    rdesikan@jetzbroadband.com
> > +P:    Arvind R.

How about putting the full name there, while you are at changing it 
anyway?

> > M:    arvind@acarlab.com

And I had to drop this address from CC while replying to this mail, as it 
doesn't resolve

	# host -t ns acarlab.com
	Host acarlab.com not found: 2(SERVFAIL)

-- 
Jiri Kosina
SUSE Labs
---1747641777-1842657311-1245844424=:31685--
