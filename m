Return-Path: <linux-kernel-owner+w=401wt.eu-S1754163AbZJVQKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbZJVQKB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 12:10:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbZJVQKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 12:10:00 -0400
Received: from gir.skynet.ie ([193.1.99.77]:43807 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074AbZJVQKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 12:10:00 -0400
Date: Thu, 22 Oct 2009 17:10:07 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Stephan von Krawczynski <skraw@ithnet.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       David Rientjes <rientjes@google.com>, Jiri Kosina <jkosina@suse.cz>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Frans Pop <elendil@planet.nl>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: page allocation failure message kernel 2.6.31.4 (tty-related)
Message-ID: <20091022161007.GT11778@csn.ul.ie>
References: <20091020153838.665bc39c.skraw@ithnet.com> <alpine.LRH.2.00.0910211848510.20992@twin.jikos.cz> <alpine.DEB.2.00.0910211409390.20010@chino.kir.corp.google.com> <20091022105902.GM11778@csn.ul.ie> <84144f020910220536k61d43e95x802c2391459e4305@mail.gmail.com> <20091022125120.GN11778@csn.ul.ie> <20091022180646.3f098911.skraw@ithnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20091022180646.3f098911.skraw@ithnet.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 06:06:46PM +0200, Stephan von Krawczynski wrote:
> On Thu, 22 Oct 2009 13:51:20 +0100
> Mel Gorman <mel@csn.ul.ie> wrote:
> >
> > What I'm going to do is prepare a set that assembles all the possible patches
> > that fix the variety of errors and get people to retest to make sure we catch
> > what is relevant, what isn't and what bugs (if any) are left. I should have
> > the set ready by the end of the day.
> 
> Feel free to send, I got lots of those messages, so a change should be very
> visible for me.
> 

You should have received the patches and test requests in a mail thread
starting with "Candidate fix for increased number of GFP_ATOMIC failures
V2".

Thanks

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
