Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637Ab0CNUoo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 16:44:44 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:39526 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753520Ab0CNUol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 16:44:41 -0400
Date: Sun, 14 Mar 2010 21:44:34 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>, netdev@vger.kernel.org
Cc: kernel list <linux-kernel@vger.kernel.org>,
       linux-bluetooth@vger.kernel.org
Subject: Re: 2.6.34-rc1: bluetooth oops
Message-ID: <20100314204434.GB5208@elf.ucw.cz>
References: <20100314201434.GE22059@elf.ucw.cz>
 <1268598500.3897.36.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268598500.3897.36.camel@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I got this after trying to use bnep for few minutes... Machine locked
> > after that, not sure if it is related.
> 
> I can't explain it since we haven't changed the BNEP code. So that might
> be a problem in the networking layer. So posting it to netdev might be a
> good idea.

Ok, I'll try using bnep some more. I had bad problems with cellphone
connection at that point, so maybe it is not easy to repeat, and it
the fact I have not seen it before may not mean much...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
