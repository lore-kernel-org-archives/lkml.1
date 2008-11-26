Return-Path: <linux-kernel-owner+w=401wt.eu-S1753663AbYKZRb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbYKZRb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 12:31:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbYKZRbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 12:31:14 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54057 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbYKZRbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 12:31:14 -0500
Date: Wed, 26 Nov 2008 18:31:13 +0100
From: Pavel Machek <pavel@suse.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: aperture_64.c: clarify that too small aperture is valid reason for this code
Message-ID: <20081126173113.GA30178@atrey.karlin.mff.cuni.cz>
References: <20081126161527.GE1983@elf.ucw.cz> <20081126163911.GZ6703@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126163911.GZ6703@one.firstfloor.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Nov 26, 2008 at 05:15:27PM +0100, Pavel Machek wrote:
> > 
> > Clarify that too small aperture is valid reason for this code.
> 
> There are lots more reasons than that, e.g. bad aperture pointing
> somewhere invalid.  I'm not sure it makes sense to list them all.

Small aperture is not "obviously invalid" and it confused me for a
while, but...

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
