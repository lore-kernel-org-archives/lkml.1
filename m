Return-Path: <linux-kernel-owner+w=401wt.eu-S1753908AbYLGUK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbYLGUK2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 15:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751066AbYLGUKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 15:10:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34496 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbYLGUKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 15:10:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pekka Paalanen <pq@iki.fi>
Subject: Re: [Bug #12154] Mmiotrace regression in 2.6.28-rc6
Date: Sun, 7 Dec 2008 21:09:42 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Steven Rostedt" <rostedt@goodmis.org>
References: <QFIA5HSHV8B.A.2aG.hoxNJB@chimera> <bfPM5B8Tx2B.A.RWH.1oxNJB@chimera> <20081204210234.4c9971aa@daedalus.pq.iki.fi>
In-Reply-To: <20081204210234.4c9971aa@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812072109.42292.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 4 of December 2008, Pekka Paalanen wrote:
> On Wed,  3 Dec 2008 22:58:03 +0100 (CET)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.27.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12154
> > Subject		: Mmiotrace regression in 2.6.28-rc6
> > Submitter	: Pekka Paalanen <pq@iki.fi>
> > Date		: 2008-11-23 13:41 (11 days old)
> > References	: http://marc.info/?l=linux-kernel&m=122744774317151&w=4
> 
> This is fixed:
> 
> http://marc.info/?l=linux-kernel&m=122746837006707&w=2
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7ee1768ddb3075ae3a0801cc2d0ea4195530a7db

Thanks, closed now.

Rafael
