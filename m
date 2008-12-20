Return-Path: <linux-kernel-owner+w=401wt.eu-S1753766AbYLTSLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbYLTSLR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 13:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbYLTSLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 13:11:03 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33329 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbYLTSLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 13:11:01 -0500
Date: Sat, 20 Dec 2008 19:10:54 +0100
From: Pavel Machek <pavel@suse.cz>
To: David Newall <davidn@davidnewall.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Halted system won't halt
Message-ID: <20081220181053.GA1621@ucw.cz>
References: <494A0711.7010804@davidnewall.com> <20081219120530.GB1599@ucw.cz> <494CE82E.90008@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <494CE82E.90008@davidnewall.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2008-12-20 23:12:22, David Newall wrote:
> Pavel Machek wrote:
> > On Thu 2008-12-18 18:47:21, David Newall wrote:
> >   
> >> "poweroff -f -p" ... strangely came back after a few seconds.
> >>     
> >
> > SMP? Care to try Mark Lord's recent patch on lkml?
> A surprise to me; yes, the kernel is configured for SMP.    (The
> hardware isn't.)  I can't find the patch.  Got another hint for me?

If hardware is UP, patch is nop :-(.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
