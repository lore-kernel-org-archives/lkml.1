Return-Path: <linux-kernel-owner+w=401wt.eu-S1755264AbXJHTxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbXJHTxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 15:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbXJHTxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 15:53:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59099 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbXJHTxf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 15:53:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc9-git5: Known regressions from 2.6.22
Date: Mon, 8 Oct 2007 22:08:50 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200710072202.34621.rjw@sisk.pl>
In-Reply-To: <200710072202.34621.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710082208.51432.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 7 October 2007 22:02, Rafael J. Wysocki wrote:
> This message contains a list of some known regressions from 2.6.22 for which
> there are no fixes in the mainline that I know of.  If any of them have been fixed
> already, please let me know.
> 
> If you know of any other unresolved regressions from 2.6.22, please let me know
> either and I'll add them to the list.

Another regression added today:

2.6.23 regression: do_nanosleep will not return

http://bugzilla.kernel.org/show_bug.cgi?id=9134
http://lkml.org/lkml/2007/10/8/59

Greetings,
Rafafel
