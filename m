Return-Path: <linux-kernel-owner+w=401wt.eu-S1752802AbZJZUzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbZJZUzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 16:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbZJZUzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 16:55:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60424 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbZJZUzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 16:55:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Fabio Comolli <fabio.comolli@gmail.com>
Subject: Re: [Bug #14372] ath5k wireless not working after suspend-resume - eeepc
Date: Mon, 26 Oct 2009 21:56:33 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <6dRYo8ss7vL.A.xRH.vre5KB@chimera> <b637ec0b0910261315u43033948ge041cf70292bfa58@mail.gmail.com>
In-Reply-To: <b637ec0b0910261315u43033948ge041cf70292bfa58@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200910262156.34052.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 October 2009, Fabio Comolli wrote:
> Still present in -rc5

Thanks for the update.

> On Mon, Oct 26, 2009 at 7:55 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.31.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14372
> > Subject         : ath5k wireless not working after suspend-resume - eeepc
> > Submitter       : Fabio Comolli <fabio.comolli@gmail.com>
> > Date            : 2009-10-03 15:36 (24 days old)
> > References      : http://lkml.org/lkml/2009/10/3/91
