Return-Path: <linux-kernel-owner+w=401wt.eu-S1754655AbYJ1T0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbYJ1T0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 15:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbYJ1T0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 15:26:41 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:57355 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbYJ1T0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 15:26:40 -0400
Date: Tue, 28 Oct 2008 20:28:13 +0100
From: Pavel Machek <pavel@suse.cz>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] w35und: remove macro magic from
	MLME_GetNextPacket()
Message-ID: <20081028192813.GG16452@elf.ucw.cz>
References: <Pine.LNX.4.64.0810280013460.9821@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810280013460.9821@melkki.cs.Helsinki.FI>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-10-28 00:14:14, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> This removes the macro magic from MLME_GetNextPacket() to de-obfuscate the
> code.

Acked-by: Pavel Machek <pavel@suse.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
