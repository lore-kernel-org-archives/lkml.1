Return-Path: <linux-kernel-owner+w=401wt.eu-S1757959AbZKRRIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959AbZKRRIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 12:08:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757712AbZKRRIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 12:08:10 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40074 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757659AbZKRRIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 12:08:09 -0500
Date: Wed, 18 Nov 2009 18:08:03 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>, San Mehat <san@google.com>,
       Iliyan Malchev <malchev@google.com>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: Status of Dream series
Message-ID: <20091118170238.GE20887@elf.ucw.cz>
References: <20091111104748.GA26975@elf.ucw.cz>
 <1258135899.6411.7.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258135899.6411.7.camel@c-dwalke-linux.qualcomm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Russell, what is the status of the "Dream" series? 
> > 
> >  [PATCH 1/3] msm: make debugging UART (for DEBUG_LL) configurable
> >  [PATCH 2/3] msm: add minimal board file for HTC Dream device
> >  [PATCH 3/3] msm: Add memory map for HTC Dream
> > 
> > Daniel Walker offered to maintain arch-msm tree, would that help? 
> 
> Yeah, I can do it for now, but I can't accept patches for it via this
> email address.. I'm in the processes of setting up the right address for
> it .. Might take till next week tho.

Ok, can I just add your acked-by, and send them to akpm/rmk? These
three are simple enough...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
