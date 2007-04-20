Return-Path: <linux-kernel-owner+w=401wt.eu-S2993285AbXDTRQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993285AbXDTRQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 13:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993289AbXDTRQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 13:16:52 -0400
Received: from gw.goop.org ([64.81.55.164]:54413 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993285AbXDTRQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 13:16:51 -0400
Message-ID: <4628F586.3040606@goop.org>
Date: Fri, 20 Apr 2007 10:16:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, pavel@suse.cz,
       linux-pm@lists.osdl.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, gregkh@suse.de
Subject: Re: [2/2] 2.6.21-rc7: known regressions
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org> <20070416003723.GM3691@stusta.de> <4628482B.6040804@goop.org> <20070420050344.GG20566@redhat.com> <46284C84.6060301@goop.org> <20070420051908.GH20566@redhat.com> <462850B3.70901@goop.org> <20070420145126.GC25051@redhat.com> <4628DC0A.60707@goop.org> <20070420160308.GB20118@redhat.com>
In-Reply-To: <20070420160308.GB20118@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
>  > Andi, I think.  I've got his firstfloor.org patches applied to this kernel.
>
> Ah, I saw you patched in CFS too, and thought it may be related.
>   

Well, I have CONFIG_FB_BACKLIGHT enabled, and it still works.

Maybe there's something in Andi's queue which is making it work?

    J
