Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbYGGCJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbYGGCJE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 22:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbYGGCIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 22:08:54 -0400
Received: from nschwqsrv02p.mx.bigpond.com ([61.9.189.234]:27192 "EHLO
	nschwqsrv02p.mx.bigpond.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750827AbYGGCIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 22:08:53 -0400
X-Greylist: delayed 10657 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Jul 2008 22:08:52 EDT
Subject: Re: 2.6.26-rc9: Reported regressions from 2.6.25
From: Nigel Cunningham <ncunningham@crca.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Rene Herman <rene.herman@keyaccess.nl>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Domenico Andreoli <cavokz@gmail.com>
In-Reply-To: <200807070057.51663.rjw@sisk.pl>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
	 <200807062356.47908.rjw@sisk.pl> <487142BA.1080508@keyaccess.nl>
	 <200807070057.51663.rjw@sisk.pl>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Mon, 07 Jul 2008 09:11:11 +1000
Message-Id: <1215385871.29880.11.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
X-RPD-ScanID: Class unknown; VirusThreatLevel unknown, RefID str=0001.0A150202.48715111.0058,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael etc.

On Mon, 2008-07-07 at 00:57 +0200, Rafael J. Wysocki wrote:
> On Monday, 7 of July 2008, Rene Herman wrote:
> > On 06-07-08 23:56, Rafael J. Wysocki wrote:
> > 
> > > BTW, the automated emails I'm sending are to let the reporters know
> > > that I'm interested in the current status of the bug.  They are free
> > > not to reply to them, but in that case I assume they don't really
> > > care whether or not I'm tracking the bugs they reported.
> > 
> > I did/do wonder by the way when I get them if I should be replying if 
> > the status is unchanged from my viewpoint...
> > 
> > I believe your automated emails say something like "please verify if 
> > this problem is still relevant" but don't spell out what do after you
> > verified that it is. It's sort of natural to take that as "I need to 
> > reply telling people it's fixed if it is but can remain silent if 
> > nothing changed".
> 
> The exact wording is
> 
> "The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed."
> 
> > Being more explicit about liking a reporter to report "yes, nothing 
> > changed" would probably be good if that IS what's wanted.
> 
> Well, I can change it to
> 
> "Please verify if it still should be listed and let me know."
> 
> if that's better.
> 

I would suggest that you should assume it's still relevant until the
bugzilla entry gets closed. The person fixing the bug should be
responsible for modifying the report to say that a patch is available
and then has been merged (or for saying it's an invalid report etc).

This way, you're making the whole process less burdensome rather than
so.

Regards,

Nigel

