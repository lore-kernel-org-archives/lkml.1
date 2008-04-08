Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbYDHVvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbYDHVvE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 17:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806AbYDHVuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 17:50:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36320 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772AbYDHVux convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 17:50:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Alessandro Suardi" <alessandro.suardi@gmail.com>
Subject: Re: 2.6.25-rc8-git5: Reported regressions from 2.6.24
Date: Tue, 8 Apr 2008 23:50:43 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>, "Adrian Bunk" <bunk@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Natalie Protasevich" <protasnb@gmail.com>
References: <200804071459.35628.rjw@sisk.pl> <5a4c581d0804071644u6922d412i943c0094dc7e2601@mail.gmail.com>
In-Reply-To: <5a4c581d0804071644u6922d412i943c0094dc7e2601@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804082350.44166.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 8 of April 2008, Alessandro Suardi wrote:
> 2008/4/7 Rafael J. Wysocki <rjw@sisk.pl>:
> 
> >  Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10384
> >  Subject         : 2.6.25-rc6-git2: warn_on_slowpath for tcp_simple_retransmit
> >  Submitter       : Alessandro Suardi <alessandro.suardi@gmail.com>
> >  Date            : 2008-04-02 00:28 (6 days old)
> >  References      : http://lkml.org/lkml/2008/4/1/408
> >  Handled-By      : Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
> >  Patch           : http://marc.info/?l=linux-netdev&amp;m=120756760521961&amp;w=2
> 
> This one is very difficult to verify. It happened exactly once in
>  now 20 days... I'll be away from the box until the weekend,
>  when I'll compile whatever kernel-of-the-day with Ilpo's fix
>  on top, if it isn't in mainline by then, and... well, keep the
>  torrents alive with an eye on the kernel logs.
> 
> Not sure what's the best thing to do with such a hard to
>  reproduce issue. Perhaps marking it fixed by Ilpo's patch,
>  and if it pops up again file a new bug linking it to the entry
>  in bugzilla ?

Well, I will close it as "unreproducible".  You can always reopen it if the
problem occurs again.

Thanks,
Rafael
