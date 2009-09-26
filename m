Return-Path: <linux-kernel-owner+w=401wt.eu-S1751890AbZIZJzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbZIZJzL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 05:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbZIZJzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 05:55:11 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35627 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbZIZJzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 05:55:10 -0400
Date: Sat, 26 Sep 2009 11:55:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-kernel@vger.kernel.org, lenz@cs.wisc.edu
Subject: Re: [PATCH] locomo.c: CodingStyle cleanups
Message-ID: <20090926095506.GD1331@ucw.cz>
References: <BD79186B4FD85F4B8E60E381CAEE190901CBF2B3@mi8nycmail19.Mi8.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901CBF2B3@mi8nycmail19.Mi8.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-09-15 20:12:27, H Hartley Sweeten wrote:
> [ARM] locomo.c: CodingStyle cleanups
> 
> EXPORT* macros should follow immediately after the closing function
> brace line.
> 
> The prototype for locomo_chip_driver() is not needed since the static
> (inline) function is located earlier in the file.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: John Lenz <lenz@cs.wisc.edu>

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
