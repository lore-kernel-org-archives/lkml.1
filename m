Return-Path: <linux-kernel-owner+w=401wt.eu-S1754995AbXLHWNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995AbXLHWNs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 17:13:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbXLHWNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 17:13:41 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41163 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752852AbXLHWNk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 17:13:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Richard Purdie <rpurdie@rpsys.net>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Date: Sat, 8 Dec 2007 23:32:46 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
References: <200712080340.49546.rjw@sisk.pl> <1197110678.4665.2.camel@localhost.localdomain>
In-Reply-To: <1197110678.4665.2.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712082332.47347.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 8 of December 2007, Richard Purdie wrote:
> On Sat, 2007-12-08 at 03:40 +0100, Rafael J. Wysocki wrote:
> > Subject		: leds: ledtrig-timer calls sleeping function from invalid context
> > Submitter	: Márton Németh <nm127@freemail.hu>
> > References	: http://bugzilla.kernel.org/show_bug.cgi?id=9264
> > Handled-By	: Richard Purdie <rpurdie@rpsys.net>
> > Patch		: http://bugzilla.kernel.org/attachment.cgi?id=13493&action=view
> 
> The fix is now in mainline:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=dc47206e552c0850ad11f7e9a1fca0a3c92f5d65

Yes, already dropped.

Thanks,
Rafael
