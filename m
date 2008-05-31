Return-Path: <linux-kernel-owner+w=401wt.eu-S1756311AbYEaWgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbYEaWgg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 18:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680AbYEaWg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 18:36:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52437 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754676AbYEaWg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 18:36:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: thunder7@xs4all.nl
Subject: Re: [Bug #10816] vt/fbcon: fix background color on line feed
Date: Sun, 1 Jun 2008 00:37:10 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@medozas.de>
References: <90LLR3uLHfN.A.NZC.LqZQIB@albercik> <UJSav77TyUB.A.ETD.2qZQIB@albercik> <20080531203919.GA1449@wl500g>
In-Reply-To: <20080531203919.GA1449@wl500g>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806010037.11280.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 31 of May 2008, thunder7@xs4all.nl wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Date: Sat, May 31, 2008 at 07:48:06PM +0200
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10816
> > Subject		: vt/fbcon: fix background color on line feed
> > Submitter	: thunder7 <thunder7@xs4all.nl>
> > Date		: 2008-05-27 19:33 (5 days old)
> > References	: http://marc.info/?l=linux-kernel&amp;m=121191733218735&amp;w=4
> > Handled-By	: Jan Engelhardt <jengelh@medozas.de>
> > Patch		: http://marc.info/?l=linux-kernel&amp;m=121199453010047&amp;w=4
> > 
> No, this regression should be unlisted, as I've tested this patch and it
> fixes the regression.

Still, have the fix reached the Linus' tree already?

Rafael
