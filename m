Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbYJ2Vfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbYJ2Vfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 17:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbYJ2Vfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 17:35:43 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:46903 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656AbYJ2Vfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 17:35:43 -0400
Date: Wed, 29 Oct 2008 22:37:16 +0100
From: Pavel Machek <pavel@suse.cz>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] w35und: remove atomic op wrappers
Message-ID: <20081029213716.GC1976@elf.ucw.cz>
References: <Pine.LNX.4.64.0810292010110.16596@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810292010110.16596@melkki.cs.Helsinki.FI>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-10-29 20:10:32, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> Use the kernel provided atomic op functions and remove the OS_ATOMIC and
> related wrapper macros.
> 

Acked-by: Pavel Machek <pavel@suse.cz>

And thanks, some code you deleted was really gross.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
