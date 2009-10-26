Return-Path: <linux-kernel-owner+w=401wt.eu-S1755071AbZJZTRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbZJZTRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754163AbZJZTRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:17:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59631 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753582AbZJZTRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:17:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Bug #14353] BUG: sleeping function called from invalid context at kernel/mutex.c:280
Date: Mon, 26 Oct 2009 20:18:38 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Miles Lane <miles.lane@gmail.com>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <6dRYo8ss7vL.A.6gH.Gse5KB@chimera> <1256584306.4237.1.camel@johannes.local>
In-Reply-To: <1256584306.4237.1.camel@johannes.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200910262018.38685.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 October 2009, Johannes Berg wrote:
> On Mon, 2009-10-26 at 19:55 +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.31.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14353
> > Subject		: BUG: sleeping function called from invalid context at kernel/mutex.c:280
> > Submitter	: Miles Lane <miles.lane@gmail.com>
> > Date		: 2009-10-05 3:39 (22 days old)
> > References	: http://marc.info/?l=linux-kernel&m=125471432208671&w=4
> 
> This should be fixed by a160ee69c6a4622ed30c377a978554015e9931cb.

OK, closing.

Thanks,
Rafael
