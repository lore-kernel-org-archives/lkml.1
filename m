Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbYJ2Vgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbYJ2Vgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 17:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbYJ2Vgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 17:36:32 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:46909 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722AbYJ2Vgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 17:36:32 -0400
Date: Wed, 29 Oct 2008 22:38:04 +0100
From: Pavel Machek <pavel@suse.cz>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] w35und: remove abs() and BIT() macros
Message-ID: <20081029213804.GE1976@elf.ucw.cz>
References: <Pine.LNX.4.64.0810292010570.16596@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810292010570.16596@melkki.cs.Helsinki.FI>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-10-29 20:11:13, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> We can use the kernel built-in abs() and BIT() macros the just fine.
> 

Acked-by: Pavel Machek <pavel@suse.cz>

> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
