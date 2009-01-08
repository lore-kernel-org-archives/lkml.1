Return-Path: <linux-kernel-owner+w=401wt.eu-S1756981AbZAHKKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981AbZAHKKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 05:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbZAHKKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 05:10:30 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60734 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbZAHKK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 05:10:29 -0500
Date: Thu, 8 Jan 2009 11:12:30 +0100
From: Pavel Machek <pavel@suse.cz>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] w35und: kill WBDEBUG and remove common.h header
	file
Message-ID: <20090108101230.GC7577@elf.ucw.cz>
References: <Pine.LNX.4.64.0901081131290.15334@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901081131290.15334@melkki.cs.Helsinki.FI>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-01-08 11:31:59, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> The only remaining thing in common.h header file is the WBDEBUG() macro which
> is unconditionally defined as printk(). Kill the macro and remove the header
> file.
> 
> Cc: Pavel Machek <pavel@suse.cz>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
