Return-Path: <linux-kernel-owner+w=401wt.eu-S1758531AbXJDOYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531AbXJDOYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 10:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756144AbXJDOYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 10:24:39 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:58841 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064AbXJDOYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 10:24:38 -0400
Date: Thu, 4 Oct 2007 16:24:37 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Arjan van de Ven <arjan@infradead.org>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, jikos@jikos.cz
Subject: Re: video resume stuff
Message-ID: <20071004142437.GA4484@atrey.karlin.mff.cuni.cz>
References: <20071004130513.GA16076@elf.ucw.cz> <20071004062848.0c55d182@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071004062848.0c55d182@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 4 Oct 2007 15:05:13 +0200
> Pavel Machek <pavel@ucw.cz> wrote:
> 
> > Hi!
> > 
> > I'm thinking about how to clean up video resume/how to get it to work
> > for non-VESA video modes (jikos' case).
> 
> 
> I suspect in the medium run, the video mode setting stuff that's moving
> into the kernel is the real answer to this problem... maybe it's more
> efficient to move that in in a hurry ;)

Violently agreed... but we still want fallback for vesafb ;-).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
