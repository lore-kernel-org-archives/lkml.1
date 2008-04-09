Return-Path: <linux-kernel-owner+w=401wt.eu-S1756518AbYDJJIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518AbYDJJIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 05:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755046AbYDJJIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 05:08:06 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2485 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753723AbYDJJIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 05:08:04 -0400
Date: Wed, 9 Apr 2008 23:01:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: build error on x86_64 with x86.git#latest
Message-ID: <20080409210138.GA9660@ucw.cz>
References: <86802c440804091036p3a3837e8td8f17d6195561aaf@mail.gmail.com> <20080409204250.GD18968@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080409204250.GD18968@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > commit 0465ac59164eda30f4fe49006a67dd6d2c9fc3cf
> > Author: Pavel Machek <pavel@suse.cz>
> > Date:   Wed Feb 20 01:48:39 2008 +0100
> > 
> >     suspend: wakeup code in c
> 
> oops, that was not meant to be pushed out at all - it was just a 
> temporary merge which clearly needed more work.
> 
> it's all fixed up now - please let me know if you still see any 
> problems.

Is there something I could do to pull this? Lu, could you post the patch
to fix the first problem you hit?
	
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
