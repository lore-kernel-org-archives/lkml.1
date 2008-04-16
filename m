Return-Path: <linux-kernel-owner+w=401wt.eu-S1758265AbYDPWz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265AbYDPWz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 18:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754461AbYDPWz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 18:55:29 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:39418 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916AbYDPWz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 18:55:27 -0400
Date: Thu, 17 Apr 2008 00:56:10 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, kernel list <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: gart: factor out common code
Message-ID: <20080416225610.GA28315@elf.ucw.cz>
References: <20080415104357.GA13441@elf.ucw.cz> <20080416130800.GH6304@elte.hu> <86802c440804161550r32186d07s36ba8c2e48e52281@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440804161550r32186d07s36ba8c2e48e52281@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Cleanup gart handling on amd64 a bit: move common code into
> >  > enable_gart_translation , and use symbolic register names where
> >  > appropriate.
> >
> >  thanks Pavel, applied.
> 
> good, pavel, can you do that on aperture_64.c?
> or I will do it.

I'd like you to help. I'm no iommu/agpgart/aperture expert...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
