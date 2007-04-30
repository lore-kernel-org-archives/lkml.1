Return-Path: <linux-kernel-owner+w=401wt.eu-S1946151AbXD3X4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946151AbXD3X4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 19:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946162AbXD3X4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 19:56:37 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:14264 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946151AbXD3X4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 19:56:36 -0400
Date: Mon, 30 Apr 2007 16:59:04 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Dave Jones <davej@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: checkpatch, a patch checking script.
Message-Id: <20070430165904.b55d6d0e.randy.dunlap@oracle.com>
In-Reply-To: <20070428030805.GA13331@redhat.com>
References: <20070423141123.GA21174@skybase>
	<20070423104534.51bac974.akpm@linux-foundation.org>
	<20070425112133.4ae86399.randy.dunlap@oracle.com>
	<20070425143011.57247c1d.akpm@linux-foundation.org>
	<20070425172447.1576c399.akpm@linux-foundation.org>
	<20070426003911.GA19383@redhat.com>
	<4630109F.6090002@oracle.com>
	<20070425200207.77a2721a.akpm@linux-foundation.org>
	<20070428030805.GA13331@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007 23:08:05 -0400 Dave Jones wrote:

> On Wed, Apr 25, 2007 at 08:02:07PM -0700, Andrew Morton wrote:
> 
>  > > Yep, I was going to mention your scripts but you beat me to it.
>  > > 
>  > > I'll be glad to help maintain such animals if wanted.
>  > > 
>  > wanted ;)
>  > 
>  > At least, it would be interesting to investigate the usefulness.  I suspect
>  > it will prove to be very useful for the little things.
> 
> Randy and I got together and hashed out a first cut at this.
> (Randy actually gutted quite a lot of what I originally wrote, so deserves
>  much kudos for improving this beyond my initial crappy version).
> You can find the script at http://www.codemonkey.org.uk/projects/checkpatch/
> There's also a git clonable tree there (only http right now).

FYI, checkpatch.pl Version 003 is now available at the URL above.


> http://www.codemonkey.org.uk/projects/checkpatch/example.log shows
> what fell out of running it on my mbox of lkml from the past month.
> Some of them are kinda noisy, and perhaps should be moved under --pedantic
> 
> I'm all ears for additional regexps, bug reports or other suggestions.
> 
> Before wiring this up to a procmail rule to scan every patch, I think it's
> probably a better idea to flesh it out a bit more.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
