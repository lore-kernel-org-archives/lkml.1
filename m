Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbXKYUI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbXKYUI0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 15:08:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756023AbXKYUIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 15:08:18 -0500
Received: from mx.treblig.org ([80.68.94.177]:2812 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756012AbXKYUIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 15:08:17 -0500
Date: Sun, 25 Nov 2007 20:08:00 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Adrian Bunk <bunk@kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: kernel bugzilla is FPOS (was: Re: "buggy cmd640" message followed by soft lockup)
Message-ID: <20071125200800.GA9808@gallifrey>
References: <200711222007.12497.elendil@planet.nl> <200711251411.16034.rjw@sisk.pl> <20071125134945.GB14171@stusta.de> <200711252107.23926.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711252107.23926.rjw@sisk.pl>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.20.3-bytemark-uml-2 (i686)
X-Uptime: 20:04:29 up 5 days, 19:17,  2 users,  load average: 0.49, 0.36, 0.29
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Rafael J. Wysocki (rjw@sisk.pl) wrote:

<snip>
 (many levels of quote)

> > > > * Bugs that sit in NEEDINFO state for more than i.e. one month should be
> > > >   automatically closed.
> > > 
> > > I agree that we probably should do something like this.
> >  
> > Not automatically.
> 
> OK, say "as a rule".

The only thing I would say is that a reporter can be in a situation
after a while where they no longer have access to the original
machine; if the bug was originally believed to be real and triaged
then it seems to make sense to differentiate that from a bug that is
just closed, just so people can know there is an issue with
a configuration.

Dave

-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
