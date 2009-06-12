Return-Path: <linux-kernel-owner+w=401wt.eu-S934234AbZFLWWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934234AbZFLWWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 18:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754693AbZFLWWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 18:22:34 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58249 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbZFLWWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 18:22:33 -0400
Date: Sat, 13 Jun 2009 00:22:29 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: Stefan Schmidt <stefan@datenfreihafen.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Greg KH <greg@kroah.com>, sop@google.com
Subject: Re: Gerrit (was Re: HTC Dream aka. t-mobile g1 support)
Message-ID: <20090612222229.GE17688@elf.ucw.cz>
References: <a55d774e0906121450x12bab7b0sc1f4de0115a1af61@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a55d774e0906121450x12bab7b0sc1f4de0115a1af61@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-06-12 14:50:21, Brian Swetland wrote:
> On Fri, Jun 12, 2009 at 10:35 AM, Stefan
> Schmidt<stefan@datenfreihafen.org> wrote:
> >> I think the intent is to have a
> >> Gerrit instance to accept contributions.  I'll have to look into
> >> whether this can be done without signing the agreement.  Right
> >> now, I can't even contribute anything, so there are a lot of
> >> issues to work out.
> >
> > Gerrit is the Android review system? I'm only interested into the kernel and
> > especially running a mainline kernel on different devices. Anyway, a public
> > review process and some more informations on what you are working and how you
> > would like to bring it mainline would help here.
> 
> Gerrit is a git patch review system that we (Google/Android) use for
> android development (kernel and otherwise).  Some other folks like
> Qualcomm, and TI (see http://review.omapzoom.org/) have adopted it

Unfortunately, it seems quite unsuitable for kernel.

Do I understand it right that to submit kernel patches I'd have to
agree to "contributors agreement", and give up my copyright? No,
sorry, I don't think I want to do that.

	(I may be willing to do that for Android proper -- after
	studying the agreement carefully, but not for GPLed kernel
	code).
	
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
