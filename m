Return-Path: <linux-kernel-owner+w=401wt.eu-S1751537AbZGSVXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbZGSVXi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 17:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbZGSVXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 17:23:37 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35903 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbZGSVXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 17:23:37 -0400
Date: Sun, 19 Jul 2009 23:23:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>
Cc: Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: HTC: touchscreen driver
Message-ID: <20090719212330.GI26511@elf.ucw.cz>
References: <20090710103243.GB7789@elf.ucw.cz> <a55d774e0907100431j3fdc4671i6b185019594367fa@mail.gmail.com> <20090713202302.GC2569@elf.ucw.cz> <20090713205749.GE2569@elf.ucw.cz> <20090713220726.GA28375@elf.ucw.cz> <d6200be20907131829o77bce3d8w8f238bc079478368@mail.gmail.com> <20090714094629.GB2076@elf.ucw.cz> <d6200be20907141507s39b54cccq9f0cedc325d3a203@mail.gmail.com> <20090714221638.GA6512@elf.ucw.cz> <d6200be20907141545k2b40b790x1af853b89517891c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6200be20907141545k2b40b790x1af853b89517891c@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Applying small patch on top of cleaned up driver should be better than
> > carrying whole driver itself, right?
> 
> Perhaps, but the only problem I encountered with this driver so far
> was when calling disable_irq from the interrupt handler stopped
> working on non-smp systems in 2.6.30 (which is another patch you
> should probably apply first).

How do I get that patch? git pull on msm-2.6.29 tree?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
