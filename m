Return-Path: <linux-kernel-owner+w=401wt.eu-S1757925AbXD0X6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925AbXD0X6R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 19:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757929AbXD0X6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 19:58:17 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:35360 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757925AbXD0X6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 19:58:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=FsK+frJcwO0FBPFKfvYXh2fTm6U9DPhZdpOddeKtheWWKaDLPRQEoXtJL0D6ve7wFZwK/U6unZe7Klx4Yq4DuEXcppBu3Z42qtssfGNa6anCAgbk4TsCjU4uhOcUHQkzG1s1D05Z1I5Uytf8xFr2pp0gsi+SgXIuhRf25Xx8g0Q=
Date: Sat, 28 Apr 2007 01:58:06 +0200
From: Domenico Andreoli <cavokz@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc7: known regressions
Message-ID: <20070427235806.GA2168@raptus.dandreoli.com>
Mail-Followup-To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <6bffcb0e0704271538v435bfd45u7e06a7f5f5e9a8b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bffcb0e0704271538v435bfd45u7e06a7f5f5e9a8b@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2007 at 12:38:07AM +0200, Michal Piotrowski wrote:
> Hi all,
> 
> Here is a list of known regressions reported after 2.6.21 release.

if this was also on a wiki page...

1) contributors (also casual ones) may update it or add new entries
2) adding a "Forwarded-To:" field and a "renew" button, regression
   reports could be fired semi-automatically to the right recipients.
   also the casual reader might bug proper maintainer simply clicking
   on the button. grave regressions would get more clicks...
3) when the new release is cut, such page is converted and saved as known
   regression list
4) a mail filter on lkml could perform some bookkeeping so people hating
   web could simply drop a message and the wiki page could update itself
   (no, not abuse itself)
5) web lovers could simply click on the links to lkml to dig into
   the regression

it looks like a simple and rudimentary bug tracker, but it is only a
regression reminder with links in the lkml flow. a distilled human-driven
regression-oriented semi-automatic lkml archive.

yes, some smart hybrid wiki/php|python thing with a db which could be
used to automatically send regression reminders..

i'm not a web developer, i'm not able to suggest the right wiki-tool. i
could offer some space on a tiny server with bandwidth but without any
email capability.

> Feel free to add new regressions/remove fixed etc.
> http://lkr.wikidot.com/list
 
what?!? it is already on a wiki page? doh! then read only the other
non-wiki ideas...

'night
domenico

-----[ Domenico Andreoli, aka cavok
 --[ http://www.dandreoli.com/gpgkey.asc
   ---[ 3A0F 2F80 F79C 678A 8936  4FEE 0677 9033 A20E BC50
