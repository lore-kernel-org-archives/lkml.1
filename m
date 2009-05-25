Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbZEYXWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbZEYXWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 19:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbZEYXV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 19:21:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41337 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056AbZEYXV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 19:21:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mattia Dongili <malattia@linux.it>
Subject: Re: [Bug #13148] resume after suspend-to-ram broken on Sony Vaio VGN-SR19VN when sony-laptop driver present
Date: Tue, 26 May 2009 01:22:02 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       fanderay <fanderay4@googlemail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Len Brown <len.brown@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <ZPPBiNHr1LC.A.9ZH.K9bGKB@chimera> <uSztiUhmDDC.A.VwB.v-bGKB@chimera> <20090524225302.GA3566@kamineko.org>
In-Reply-To: <20090524225302.GA3566@kamineko.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905260122.03550.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 May 2009, Mattia Dongili wrote:
> On Sun, May 24, 2009 at 09:11:50PM +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.29.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13148
> > Subject		: resume after suspend-to-ram broken on Sony Vaio VGN-SR19VN when sony-laptop driver present
> > Submitter	: fanderay <fanderay4@googlemail.com>
> > Date		: 2009-04-22 14:39 (33 days old)
> 
> sorry for not mentioning this before, but it looks like this regression
> was introduced between .28 and .29

Thanks, moved to the other list.

Rafael
