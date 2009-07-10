Return-Path: <linux-kernel-owner+w=401wt.eu-S1754296AbZGJIt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbZGJIt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 04:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbZGJItQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 04:49:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:49123 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979AbZGJItP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 04:49:15 -0400
Date: Fri, 10 Jul 2009 10:49:14 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT-PULL] includecheck fixes
In-Reply-To: <1247197301.2423.16.camel@ht.satnam>
Message-ID: <alpine.LNX.2.00.0907101047550.27327@wotan.suse.de>
References: <1247063308.4382.12.camel@ht.satnam>  <1247164809.2452.9.camel@ht.satnam>  <20090709222626.GA32746@kroah.com>  <1247194755.2423.7.camel@ht.satnam>  <1247196176.3898.158.camel@mulgrave.site> <1247197301.2423.16.camel@ht.satnam>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jul 2009, Jaswinder Singh Rajput wrote:

> > > > > Please pull includecheck fixes, these all are clean and safe
> > > > > patches with relevant Acks.
> > > > Shouldn't stuff like this go through the trivial tree?  And stuff 
> > > > like that is relevant for the main pre-rc1 merge, not this late in 
> > > > the merge cycle, right?
> > > You did not specified what is your problem ? and where was you when 
> > > we discussed it earlier ?
> > The problem, as you have been told several times, is that maintainers 
> > are very busy people and don't necessarily have time to deal with 
> > mechanical replacement trivia like this.
> Am I asking you ? If you are very busy and not able to handle things 
> properly, so better quit the maintainer-ship. Others can handle more 
> better than you.

Come on Jaswinder ... trivial grammar/typo fixes are really not that 
important stuff to argue about in longish threads. Let's rather find a 
more interesting and important topic to flame each other about :) This is 
really not worth it.

> > The point is that Jiri Kosina takes that burden on himself to verify 
> > and submit the changes like this, so something like this should go 
> > through him.
> Who will take burden of Jiri, I already send another PULL request to 
> Jiri.

If you mean the "foo foo" replacement request, the repository you asked me
to pull from doesn't seem to have any extra patches on top of current
tree, so I guess you forgot to push.

Also you can't expect that I react to trivial patches very promptly. There
are a lot of more urgent things that I am taking care of, this is just an
"add-on".

Thanks,

-- 
Jiri Kosina
SUSE Labs

