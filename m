Return-Path: <linux-kernel-owner+w=401wt.eu-S1761612AbXINM0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761612AbXINM0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 08:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754284AbXINM0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 08:26:09 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4748 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982AbXINM0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 08:26:08 -0400
Date: Fri, 14 Sep 2007 14:26:33 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Sam Ravnborg <sam@ravnborg.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: [announce] CFS-devel, performance improvements
In-Reply-To: <20070913190125.GC27146@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0709141405130.1817@scrub.home>
References: <20070911200459.GA6974@elte.hu> <Pine.LNX.4.64.0709120242040.1817@scrub.home>
 <20070913075258.GA9173@elte.hu> <Pine.LNX.4.64.0709131419170.1817@scrub.home>
 <20070913190125.GC27146@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 13 Sep 2007, Sam Ravnborg wrote:

> I have read the announcement from Ingo and after reading it I concluded
> that it was good to see that Ingo had taken in consideration the feedback
> from you and improved the schduler based on this.
> And when I read that he removed a lot of stuff I smiled. This reminded
> me of countless monkey aka code review sessions where I repeatedly do
> like my childred and asks why so many times that the author realize that
> something is not needed or no longer used.
> 
> 
> The above were my impression after reading the announcement with
> respect to your influence and that goes far beyond "two cleanups".
> I bet many others read it roughly like I did.

Sam, in a way you actually prove my point. Thanks. :)
The primary thing you remember here from the announcements is the cleanup 
and tuning part, during which he picked up some small parts from my patch.

That's what I was afraid of, most people won't realize what was added in 
this process and even if they notice it, Ingo describes it somewhat 
"similiar", but actually "different". That part is pretty important to me, 
but Ingo treats it more as a minor matter.

bye, Roman
