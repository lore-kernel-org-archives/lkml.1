Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520AbZJ1SrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbZJ1SrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 14:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755441AbZJ1SrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 14:47:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45493 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbZJ1SrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 14:47:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [Bug #14408] sysctl check failed
Date: Wed, 28 Oct 2009 19:48:50 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Peter Teoh" <htmldeveloper@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <6dRYo8ss7vL.A.74F.Ore5KB@chimera> <m1k4ygcgsy.fsf@fess.ebiederm.org>
In-Reply-To: <m1k4ygcgsy.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910281948.50830.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 October 2009, Eric W. Biederman wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.31.  Please verify if it still should be listed and let me know
> > (either way).
> 
> I believe Andrew has the fix in the -mm tree.
> 
> This is a bug but not a regression as the sysctl_check code had this bug from
> day one.

OK, so I'm dropping this one from the list of recent regressions.

Thanks,
Rafael
