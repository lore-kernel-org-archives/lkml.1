Return-Path: <linux-kernel-owner+w=401wt.eu-S1753711Ab0AQNmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab0AQNmu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 08:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258Ab0AQNmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 08:42:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40241 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985Ab0AQNmt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 08:42:49 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
Subject: Re: Boot hangs after "Freeing initrd memory" with 2.6.31.11
Date: Sun, 17 Jan 2010 14:43:16 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: Yinghai Lu <yinghai@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       hpa@zytor.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
       jaswinder@kernel.org, stable@kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <4B4E1633.8010700@pardus.org.tr> <201001162312.34189.rjw@sisk.pl> <4B52CDA0.7050909@pardus.org.tr>
In-Reply-To: <4B52CDA0.7050909@pardus.org.tr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001171443.16214.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 January 2010, Ozan Çağlayan wrote:
> Rafael J. Wysocki wrote:
> > On Saturday 16 January 2010, Ozan Çağlayan wrote:
> 
> >>>
> >>> I think that the commit should be reverted or a fix should be released for linux-2.6 tree,
> >>> as well as .31 and .32 stable trees.
> >>
> >> Linux 2.6.31 is released on Sep 9th. So people having an Athlon XP processor + a kernel newer than 4 months
> >> which enables CONFIG_X86_CPU_DEBUG can't even boot into a linux kernel. I was *at least* expecting a comment from the relevant
> >> people but nope for 2 days.
> >>
> >> It seems to be a serious regression which doesn't get caught. I'm also CC'ing Rafael, maybe he can inject this
> >> in one of his regression threads.
> > 
> > Well, the problem is I'm not listing regressions from 2.6.31 any more.

I should have said "from 2.6.30" actually. 

Rafael
