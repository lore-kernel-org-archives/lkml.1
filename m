Return-Path: <linux-kernel-owner+w=401wt.eu-S1758479AbYFITxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479AbYFITxB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 15:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbYFITww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 15:52:52 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:33524 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbYFITwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 15:52:51 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: "Justin Mattock" <justinmattock@gmail.com>
Subject: Re: [Bug #10825] appletouch after wakeup
Date: Mon, 9 Jun 2008 21:53:09 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <GIilET9wkhI.A.JzB.81vSIB@albercik> <200806091107.51994.oliver@neukum.org> <dd18b0c30806090918j1426bd6etf78a20a87a0528f3@mail.gmail.com>
In-Reply-To: <dd18b0c30806090918j1426bd6etf78a20a87a0528f3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806092153.09686.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 09 Juni 2008 18:18:19 schrieb Justin Mattock:
> On Mon, Jun 9, 2008 at 9:07 AM, Oliver Neukum <oliver@neukum.org> wrote:
> > Am Samstag 07 Juni 2008 22:42:57 schrieb Rafael J. Wysocki:
> >> This message has been generated automatically as a part of a report
> >> of recent regressions.
> >>
> >> The following bug entry is on the current list of known regressions
> >> from 2.6.25.  Please verify if it still should be listed.
> >>
> >>
> >> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=10825
> >> Subject               : appletouch after wakeup
> >> Submitter     : Justin Mattock <justinmattock@gmail.com>
> >> Date          : 2008-05-27 3:29 (12 days old)
> >> References    : http://marc.info/?l=linux-kernel&amp;m=121185900618047&amp;w=4
> >>                 http://lkml.org/lkml/2008/5/31/193
> >>                 http://lkml.org/lkml/2008/5/31/193
> >> Handled-By    : Oliver Neukum <oliver@neukum.org>
> >
> > A patch is available but not yet in mainline.
> >
> >        Regards
> >                Oliver
> >
> 
> Cool; just an update, I've suspended the system numerous times it
> seems appletouch is behaving correctly, in fact
> I think better, why: when I start the system I have two finger scroll
> functionality, then when suspending the system
> after waking up the two finger scroll is still functional.
> regards;
> 

With last week's patch or today's patch?

	Regards
		Oliver

