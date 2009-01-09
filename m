Return-Path: <linux-kernel-owner+w=401wt.eu-S1757038AbZAIKGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038AbZAIKGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 05:06:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754943AbZAIKGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 05:06:20 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47871 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780AbZAIKGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 05:06:20 -0500
Date: Fri, 9 Jan 2009 11:08:26 +0100
From: Pavel Machek <pavel@suse.cz>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w35und: typedef removal
Message-ID: <20090109100826.GB3396@elf.ucw.cz>
References: <Pine.LNX.4.64.0901081830380.7049@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901081830380.7049@melkki.cs.Helsinki.FI>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-01-08 18:32:14, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> This patch removes some typedefs from the driver code. I also removed some 
> unused structs I spotted while removing the typedefs.
> 
> Cc: Pavel Machek <pavel@suse.cz>

ACK and thanks. This was long overdue.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
