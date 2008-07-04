Return-Path: <linux-kernel-owner+w=401wt.eu-S1754609AbYGDWrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbYGDWrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 18:47:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbYGDWq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 18:46:59 -0400
Received: from roath.org ([87.106.182.47]:35360 "EHLO mail.roath.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750919AbYGDWq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 18:46:58 -0400
X-Greylist: delayed 1685 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Jul 2008 18:46:58 EDT
Date: Sat, 5 Jul 2008 00:18:48 +0200
To: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.25.10
Message-ID: <20080704221847.GA3761@master.roath.intern>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <555236.75770.qm@web52912.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <555236.75770.qm@web52912.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: sroas@roath.org (Stefan Roas)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu Jul 03, 2008 at 16:42:01, Chris Rankin wrote:
> > Again, if the above information is somehow insufficient as to what
> > exactly is fixed in the -stable releases, and anyone has questions about
> > how these release announcements are created, please let me know.
> 
> Well, for example:
> 
> I have only machines with 32 bit CPUS, none of them is hot-pluggable and none has an i915 graphics chip. All my local users are "trusted", nor am I running any multi-threaded Java applications on SMP systems. (I also have no idea what ICM pages are, but they sound jolly impressive!)
> 
> And what is "native_read_tscp" all about?

To some degree I can understand that you are not sure of whether you are
affected or not. On the other hand you should probably be, when running
your own kernels on a productive system. After all there seems to be a
general agreement that distribution vendors take care of the stabilization
and bug fixing of their particular kernels. As far as I am
concerned, I'm grateful that there are these stable releases at all and I very
much consider it additional work for everyone in the release team. To that
end it should be your task to check whether the update affects you or not.

After all the releases are publicly announced on probably the busiest
mailing list on earth. That offers anyone the chance to add additional
information to the releases (there has been a discussion recently about
security implications that weren't mentioned in the announcement. Just
replying to the announcement will add the needed information, and as the
discussion showed, people actually do add information).

To sum all the above up: IMHO the announcements are great, the work of the
stable team is great and I wouldn't really want to push more work on the
people that voluntarily spend their time on this branch by explaining every
detail of every patch.

Just my 2 cents.

Best regards,
  Stefan
