Return-Path: <linux-kernel-owner+w=401wt.eu-S932407AbZKRS0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407AbZKRS0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 13:26:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932329AbZKRS0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 13:26:35 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55718 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932318AbZKRS0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 13:26:34 -0500
Date: Wed, 18 Nov 2009 19:25:29 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>, San Mehat <san@google.com>,
       Daniel Walker <dwalker@fifo99.com>, Iliyan Malchev <malchev@google.com>
Subject: Re: Status of Dream series
Message-ID: <20091118182529.GL25150@elf.ucw.cz>
References: <20091111104748.GA26975@elf.ucw.cz>
 <20091116163946.GC3568@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091116163946.GC3568@n2100.arm.linux.org.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-11-16 16:39:46, Russell King - ARM Linux wrote:
> On Wed, Nov 11, 2009 at 11:47:48AM +0100, Pavel Machek wrote:
> > 
> > Russell, what is the status of the "Dream" series? 
> > 
> >  [PATCH 1/3] msm: make debugging UART (for DEBUG_LL) configurable
> >  [PATCH 2/3] msm: add minimal board file for HTC Dream device
> >  [PATCH 3/3] msm: Add memory map for HTC Dream
> 
> See my reply today on patch 2/3; that is my only comment.

Good, so it is ok to add reviewed-by: tags on the fixed versions?

> > Daniel Walker offered to maintain arch-msm tree, would that help? 
> 
> I thought from Daniel's private email to me on the 2/11 that this was
> his intention; I didn't see a question in it requiring an answer.

So... Daniel is now the new arch-msm maintainer? Good.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
