Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab0BHAIs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 19:08:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55374 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754549Ab0BHAIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 19:08:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [Bug #15202] lockdep warning during elevator_switch
Date: Mon, 8 Feb 2010 01:08:56 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc7-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
References: <4Ht3jFrT7uE.A.JI.-nzbLB@chimera> <445R0ey9hAI.A.h3.RozbLB@chimera> <alpine.LSU.2.00.1002072334290.22220@sister.anvils>
In-Reply-To: <alpine.LSU.2.00.1002072334290.22220@sister.anvils>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002080108.56180.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 February 2010, Hugh Dickins wrote:
> On Sun, 7 Feb 2010, Rafael J. Wysocki wrote:
> 
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15202
> > Subject		: lockdep warning during elevator_switch
> > Submitter	: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> > Date		: 2010-01-31 23:55 (8 days old)
> > References	: http://marc.info/?l=linux-kernel&m=126498212613051&w=4
> 
> Yes, still so in 2.6.33-rc7.

Thanks for the update.

Rafael
