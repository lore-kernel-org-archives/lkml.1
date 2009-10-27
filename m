Return-Path: <linux-kernel-owner+w=401wt.eu-S932193AbZJ0I2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193AbZJ0I2o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 04:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932131AbZJ0I2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 04:28:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34675 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932130AbZJ0I2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 04:28:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yong Zhang <yong.zhang0@gmail.com>
Subject: Re: [Bug #14481] umount blocked for more than 120 seconds after USB drive removal
Date: Tue, 27 Oct 2009 09:30:41 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Robert Hancock <hancockrwd@gmail.com>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <6dRYo8ss7vL.A.x7E.4qe5KB@chimera> <2674af740910261904m13985d9ck46e5d665517ca6a6@mail.gmail.com>
In-Reply-To: <2674af740910261904m13985d9ck46e5d665517ca6a6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200910270930.41241.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 October 2009, Yong Zhang wrote:
> On Tue, Oct 27, 2009 at 2:56 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.31.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14481
> > Subject         : umount blocked for more than 120 seconds after USB drive removal
> > Submitter       : Robert Hancock <hancockrwd@gmail.com>
> > Date            : 2009-10-21 5:26 (6 days old)
> > References      : http://marc.info/?l=linux-kernel&m=125610280532245&w=4
> >
> >
> 
> I met the same problem on 2.6.32-rc5

Thanks for the information.

Rafael
