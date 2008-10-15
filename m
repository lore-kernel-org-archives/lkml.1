Return-Path: <linux-kernel-owner+w=401wt.eu-S1754828AbYJOMDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbYJOMDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 08:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbYJOMDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 08:03:41 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44050 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbYJOMDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 08:03:40 -0400
Date: Wed, 15 Oct 2008 14:03:39 +0200
From: Pavel Machek <pavel@suse.cz>
To: Eric Piel <eric.piel@tremplin-utc.net>
Cc: lm-sensors@lm-sensors.org, kernel list <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>, Tejun Heo <tj@kernel.org>,
       Yan Burman <burman.yan@gmail.com>
Subject: Re: Accelerometer driver for HP laptops
Message-ID: <20081015120339.GE4247@atrey.karlin.mff.cuni.cz>
References: <48C984F5.5000804@tudelft.nl> <200809120736.06594.trenn@suse.de> <48CAD89F.1050806@tremplin-utc.net> <20081015072511.GA20607@atrey.karlin.mff.cuni.cz> <48F5A0C8.1080102@tremplin-utc.net> <20081015105805.GD4247@atrey.karlin.mff.cuni.cz> <48F5D1F1.3060702@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F5D1F1.3060702@tremplin-utc.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> I've got already a changelog ready. Give me a couple of days to clean
> >> things up and I'll send it to akpm myself :-)
> > 
> > Ok, I'd like to help with cleaning... let me know if I can help some more.
> Hi,
> Thanks a lot for this patch.

You are welcome.

> > * remove /** from comments that are not linuxdoc compliant.
> Hum... I'll try to fix the comments to make them linuxdoc compliant. I
> must be missing something obvious, but do you know where is the doc
> about linuxdoc?

Documentation/kernel-doc-nano-HOWTO.txt, AFAICT. It took me a while to
find.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
