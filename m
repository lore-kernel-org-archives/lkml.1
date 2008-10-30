Return-Path: <linux-kernel-owner+w=401wt.eu-S1756769AbYJ3RXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbYJ3RXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 13:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645AbYJ3RWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 13:22:52 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37344 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754502AbYJ3RWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 13:22:52 -0400
Date: Thu, 30 Oct 2008 18:22:39 +0100
From: Pavel Machek <pavel@suse.cz>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] w35und: remove some dead code
Message-ID: <20081030172238.GD1670@ucw.cz>
References: <Pine.LNX.4.64.0810301304300.6842@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810301304300.6842@melkki.cs.Helsinki.FI>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-10-30 13:04:58, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> This patch removes the WBLinux_ReceivePacket(), WBLINUX_GetNextPacket(),
> WBLINUX_GetNextPacketCompleted, and sme_get_rssi() functions, which execute
> BUG() unconditionally, and related dead code.
> 

Acked-by: Pavel Machek <pavel@suse.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
