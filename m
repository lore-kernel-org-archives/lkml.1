Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbZG0VzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbZG0VzO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 17:55:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755213AbZG0VzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 17:55:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36718 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754740AbZG0VzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 17:55:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug #13472] Oops with minicom and USB serial
Date: Mon, 27 Jul 2009 23:55:34 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Peter Chubb <peterc@gelato.unsw.edu.au>
References: <Pine.LNX.4.44L0.0907271039260.5614-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0907271039260.5614-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907272355.35592.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 July 2009, Alan Stern wrote:
> On Sun, 26 Jul 2009, Rafael J. Wysocki wrote:
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.29 and 2.6.30.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13472
> > Subject		: Oops with minicom and USB serial
> > Submitter	: Peter Chubb <peterc@gelato.unsw.edu.au>
> > Date		: 2009-06-05 1:37 (52 days old)
> > References	: http://marc.info/?l=linux-kernel&m=124416901026700&w=4
> > Handled-By	: Alan Stern <stern@rowland.harvard.edu>
> 
> This bug has been fixed in 2.6.30.stable by commit
> b6cd9d132aa5e2ef0abdd1d5171e45dad9aafc29.

Thanks, closed.

Rafael
