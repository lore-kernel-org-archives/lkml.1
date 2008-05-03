Return-Path: <linux-kernel-owner+w=401wt.eu-S933325AbYECSOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933325AbYECSOh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 14:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766014AbYECSO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 14:14:29 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:43146 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765716AbYECSO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 14:14:29 -0400
Date: Sat, 3 May 2008 20:15:03 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Roland McGrath <roland@redhat.com>,
       Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] fix rebuild of wakeup.bin
Message-ID: <20080503181503.GB17990@uranus.ravnborg.org>
References: <20080501010516.DD2FE26FA05@magilla.localdomain> <20080501093107.GA2392@uranus.ravnborg.org> <200805011248.53295.rjw@sisk.pl> <20080503180612.GD5292@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080503180612.GD5292@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2008 at 08:06:12PM +0200, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > > Add wakeup.lds to list af targets to avoid rebuilding wakeup.bin - 
> > > from Roland McGrath.
> > 
> > Thanks for fixing this!
> > 
> > Ingo, please merge.
> 
> applied - thanks all!

Just a note - I do not think this solves the problem Daniel
has reported with respect to first build of -next.
I am awaiting more data before I can analyse it further.

	Sam
