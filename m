Return-Path: <linux-kernel-owner+w=401wt.eu-S933245AbZJLVey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933245AbZJLVey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 17:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933213AbZJLVex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 17:34:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36255 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933202AbZJLVex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 17:34:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [Bug #14267] Disassociating atheros wlan
Date: Mon, 12 Oct 2009 23:35:53 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc3-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <L6tb-VyKHZK.A.AQC.izl0KB@chimera> <4AD2662A.5050709@gmail.com>
In-Reply-To: <4AD2662A.5050709@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200910122335.53753.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 October 2009, Justin P. Mattock wrote:
> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.30 and 2.6.31.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> > be listed and let me know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14267
> > Subject		: Disassociating atheros wlan
> > Submitter	: Kristoffer Ericson<kristoffer.ericson@gmail.com>
> > Date		: 2009-09-24 10:16 (18 days old)
> > References	: http://marc.info/?l=linux-kernel&m=125378723723384&w=4
> >
> >
> >
> >    
> I attached my bisect log to the bug report, but did not individually test
> some of the commits in the log to see if it finds the issue.
> (I can try later on and see).
> 
> so for now I say yes keep it open.

OK, thanks for the update.

Rafael
