Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbXFNPdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbXFNPdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 11:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbXFNPdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 11:33:45 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:57146 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbXFNPdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 11:33:44 -0400
Message-ID: <46715FD4.6040803@s5r6.in-berlin.de>
Date: Thu, 14 Jun 2007 17:33:40 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Oleg Verych <olecom@flower.upol.cz>
CC: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: regression tracking (Re: Linux 2.6.21)
References: <20070426040806.GJ3468@stusta.de> <p73d51n1fup.fsf@bingen.suse.de> <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org> <200704291849.23197.rjw@sisk.pl> <20070429173725.GB30248@one.firstfloor.org> <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org> <E1HyipW-0005wJ-0Q@flower>
In-Reply-To: <E1HyipW-0005wJ-0Q@flower>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Verych wrote:
> I'm seeing this long (198) thread and just have no idea how it has
> ended (wiki? hand-mailing?).

Direct or indirect results:

  - See Michal Piotrowski's periodic posts and
    http://kernelnewbies.org/known_regressions .

  - Meanwhile, the people who maintain bugzilla.kernel.org seem to work
    on improvements.  I noticed that (a) each page now has a backlink to
    the bugzilla.kernel.org start page, (b) the show_bug.cgi=... page
    layout is now an unreadable mess, (c) e-mail integration is still
    the same (it's impossible at least for me to send e-mails to bugs).

[...]
> Why you didn't proposed (used) Debian's BTS as alternative to bugzilla,
[...]

BTS has been mentioned in that thread in a few posts; mostly positively
as I recall.
-- 
Stefan Richter
-=====-=-=== -==- -===-
http://arcgraph.de/sr/
