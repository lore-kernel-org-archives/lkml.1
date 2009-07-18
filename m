Return-Path: <linux-kernel-owner+w=401wt.eu-S1753774AbZGRUUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774AbZGRUUh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 16:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753744AbZGRUUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 16:20:36 -0400
Received: from max.feld.cvut.cz ([147.32.192.36]:58609 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753737AbZGRUUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 16:20:35 -0400
X-Greylist: delayed 463 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Jul 2009 16:20:35 EDT
From: Michal Sojka <sojkam1@fel.cvut.cz>
To: Raistlin <raistlin@linux.it>
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
Date: Sat, 18 Jul 2009 22:12:14 +0200
User-Agent: KMail/1.9.9
Cc: Ted Baker <baker@cs.fsu.edu>, "James H. Anderson" <anderson@cs.unc.edu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Chris Friesen <cfriesen@nortel.com>,
       Douglas Niehaus <niehaus@ittc.ku.edu>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>,
       Bjoern Brandenburg <bbb@cs.unc.edu>
References: <1247336891.9978.32.camel@laptop> <20090715205503.GA14993@cs.fsu.edu> <1247786951.4929.52.camel@Palantir>
In-Reply-To: <1247786951.4929.52.camel@Palantir>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907182212.15355.sojkam1@fel.cvut.cz>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 of July 2009 01:29:11 Raistlin wrote:
> On Wed, 2009-07-15 at 16:55 -0400, Ted Baker wrote:
> > In the deadline scheduling domain, we have algorithms like
> > Constant Bandwidth Server (and some improved variants) that
> > provide similar gurantees and limites, in terms of deadlines.  (I
> > recall seeing one very good version in a paper I recently saw,
> > which I could seek out and provide to the list if there is
> > interest.)
>
> Well, if it does not bother you too much, I'm curious about that
> solution... When you find some time, even via private mail, if I'm the
> only one, it would be nice if you can point that paper out to me.

Hi,
I'm also interested in this, so please, send the pointers publically,

Michal
