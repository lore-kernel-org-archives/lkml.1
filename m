Return-Path: <linux-kernel-owner+w=401wt.eu-S933553AbYETV5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933553AbYETV5B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 17:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761100AbYETV4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 17:56:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46582 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758970AbYETV4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 17:56:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Ioan Ionita" <opslynx@gmail.com>
Subject: Re: 2.6.26-rc2-git5: Reported regressions from 2.6.25
Date: Tue, 20 May 2008 23:56:36 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Adrian Bunk" <bunk@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Natalie Protasevich" <protasnb@gmail.com>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik> <df47b87a0805191334j5768cdb6i977ea6dfc7cd9b63@mail.gmail.com>
In-Reply-To: <df47b87a0805191334j5768cdb6i977ea6dfc7cd9b63@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805202356.37592.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 19 of May 2008, Ioan Ionita wrote:
> On Sun, May 18, 2008 at 2:10 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message contains a list of some regressions from 2.6.25, for which there
> > are no fixes in the mainline I know of.  If any of them have been fixed already,
> > please let me know.
> 
> There is a patch available for the regression below. I have tested it
> and it has fixed my issue. Thank you Miklos Szeredi! Patch available
> at: http://marc.info/?l=linux-kernel&m=121122564714638&w=2
> 
> 
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10742
> > Subject         : BISECTED REGRESSION: 2.6.26-rc2: FUSE changes break mount of ntfs-3g
> > Submitter       : Ioan Ionita <opslynx@gmail.com>
> > Date            : 2008-05-17 20:37 (2 days old)
> > References      : http://marc.info/?l=linux-kernel&amp;m=121105669717787&amp;w=4
> 

Bugzilla entry updated with the patch link.

Thanks,
Rafael
