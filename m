Return-Path: <linux-kernel-owner+w=401wt.eu-S1760786AbYBYXht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760786AbYBYXht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 18:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756514AbYBYXhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 18:37:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:32970 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755270AbYBYXhl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 18:37:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Subject: Re: 2.6.25-rc3: Reported regressions from 2.6.24
Date: Tue, 26 Feb 2008 00:36:15 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <200802250241.40832.rjw@sisk.pl> <20080225182418.GA3140@ubuntu>
In-Reply-To: <20080225182418.GA3140@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802260036.16059.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 25 of February 2008, Ahmed S. Darwish wrote:
> On Mon, Feb 25, 2008 at 02:41:40AM +0100, Rafael J. Wysocki wrote:
> > This message contains a list of some regressions from 2.6.24 reported since
> > 2.6.25-rc1 was released, for which there are no fixes in the mainline I know
> > of.  If any of them have been fixed already, please let me know.
> > 
> > If you know of any other unresolved regressions from 2.6.24, please let me know
> > either and I'll add them to the list.  Also, please let me know if any of the
> > entries below are invalid.
> > 
> 
> There's an lguest Oops reported here:
> 
> http://lkml.org/lkml/2008/2/24/136
> 
> and a patch in the same report. It's not yet approved by Rusty, but
> Ingo thinks it's fine.

Added, http://bugzilla.kernel.org/show_bug.cgi?id=10105 .

Thanks,
Rafael
