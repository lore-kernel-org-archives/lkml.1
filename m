Return-Path: <linux-kernel-owner+w=401wt.eu-S1753097AbZGKXFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbZGKXFe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 19:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbZGKXFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 19:05:25 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44412 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbZGKXFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 19:05:24 -0400
Date: Sun, 12 Jul 2009 01:05:09 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Walker <dwalker@fifo99.com>
Cc: greg@kroah.com, swetland@google.com, malchev@google.com,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: HTC Dream: qdsp support for staging
Message-ID: <20090711230509.GA4705@elf.ucw.cz>
References: <20090710083709.GA6418@elf.ucw.cz> <1247246757.7146.33.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247246757.7146.33.camel@desktop>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-07-10 10:25:57, Daniel Walker wrote:
> On Fri, 2009-07-10 at 10:37 +0200, Pavel Machek wrote:
> > From: Iliyan Malchev <ibm@android.com>
> > 
> > QDSP code is neccessarry for communication with some hardware
> > components on HTC Dream, including camera hardware. It also drives DSP
> > coproccessor.
> > 
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> You don't want to break it up into multiple patches? I'll do it if you
> don't want too ..

I don't know how much sense it makes to split it further... yes, I
could probably split it per file or something but...

(Notice that this is going to be rewriten in staging, anyway, before
merging into kernel proper...)
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
