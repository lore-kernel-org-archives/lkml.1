Return-Path: <linux-kernel-owner+w=401wt.eu-S1757467AbYJ3RYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467AbYJ3RYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 13:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645AbYJ3RYC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 13:24:02 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:53086 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754403AbYJ3RYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 13:24:01 -0400
Date: Thu, 30 Oct 2008 18:23:51 +0100
From: Pavel Machek <pavel@suse.cz>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] w35und: move source files to one directory
Message-ID: <20081030172351.GE1670@ucw.cz>
References: <Pine.LNX.4.64.0810301304590.6842@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810301304590.6842@melkki.cs.Helsinki.FI>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-10-30 13:05:42, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> As we're trying to get rid of the "compatability layer" in the driver, move
> everything under one directory. Keeping some of the files under
> drivers/staging/winbond/linux is a major pain in the ass whenever you're
> cleaning up the driver.

Acked-by: Pavel Machek <pavel@suse.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
