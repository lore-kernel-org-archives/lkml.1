Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1754264AbYJAUEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbYJAUEP (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 1 Oct 2008 16:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbYJAUD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 16:03:58 -0400
Received: from kroah.org ([198.145.64.141]:35217 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753844AbYJAUD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 16:03:57 -0400
Date: Wed, 1 Oct 2008 13:00:39 -0700
From: Greg KH <greg@kroah.com>
To: TJ <linux@tjworld.net>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Casual J. Programmer" <casualprogrammer@googlemail.com>
Subject: Re: Agere Hermes source-code: copyright situation
Message-ID: <20081001200039.GA29874@kroah.com>
References: <200809290949.35749.arvidjaar@mail.ru> <20081001031907.GA19181@kroah.com> <200810011413.17059.arvidjaar@mail.ru> <1222879229.17264.4.camel@hephaestion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222879229.17264.4.camel@hephaestion>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2008 at 05:40:29PM +0100, TJ wrote:
> On Wed, 2008-10-01 at 14:13 +0400, Andrey Borzenkov wrote:
> > And it is not GPL'ed, of course. I attach E-Mail I received a while
> > back with answere from Agere legal department.
> 
> I'm attaching the original email I sent to Agere and their response for
> the record, hoping it helps clarify the legal position.

Very nice, thanks for forwarding this on.

As the license is BSD, that means we can place it in the kernel tree.
Do you all mind if I add it to the drivers/staging/ directory so you can
work on cleaning it up within the main kernel tree infrastructure?

thanks,

greg k-h
