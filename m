Return-Path: <linux-kernel-owner+w=401wt.eu-S1754738AbYJ1TQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbYJ1TQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 15:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbYJ1TQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 15:16:05 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34446 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbYJ1TQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 15:16:02 -0400
Date: Tue, 28 Oct 2008 20:17:36 +0100
From: Pavel Machek <pavel@suse.cz>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] w35und: remove true/false boolean macros
Message-ID: <20081028191736.GC16452@elf.ucw.cz>
References: <Pine.LNX.4.64.0810272245380.7561@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810272245380.7561@melkki.cs.Helsinki.FI>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-10-27 22:46:39, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> Use the kernel built-in true and false boolean values instead of duplicating
> them in the driver code.
> 

Acked-by: Pavel Machek <pavel@suse.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
