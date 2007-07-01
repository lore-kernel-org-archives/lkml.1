Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbXGAXE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbXGAXE6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 19:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbXGAXEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 19:04:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38741 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbXGAXEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 19:04:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: [-mm patch] kernel/power/main.c: make code static
Date: Mon, 2 Jul 2007 01:12:03 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <20070628034321.38c9f12b.akpm@linux-foundation.org> <20070701202336.GV10869@stusta.de>
In-Reply-To: <20070701202336.GV10869@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707020112.04013.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 1 July 2007 22:23, Adrian Bunk wrote:
> On Thu, Jun 28, 2007 at 03:43:21AM -0700, Andrew Morton wrote:
> >...
> > Changes since 2.6.22-rc4-mm2:
> >...
> > +pm-reduce-code-duplication-between-mainc-and-userc.patch
> >...
> >  PM updates
> >...
> 
> 
> Some code can now become static.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

This clashes and partially overlaps with some patches that I have in the works.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
