Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbYJUJ2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbYJUJ2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 05:28:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbYJUJ16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 05:27:58 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43810 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbYJUJ15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 05:27:57 -0400
Date: Tue, 21 Oct 2008 11:27:56 +0200
From: Pavel Machek <pavel@suse.cz>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w35und: use gotos for error handling
Message-ID: <20081021092756.GA29632@atrey.karlin.mff.cuni.cz>
References: <Pine.LNX.4.64.0810211214120.31513@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810211214120.31513@melkki.cs.Helsinki.FI>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> The driver code uses do { } while (0) together with the break statement to
> emulate gotos for error handling. Fix that up by using the goto statement
> instead.
> 
> Cc: Pavel Machek <pavel@suse.cz>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

ACK.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
