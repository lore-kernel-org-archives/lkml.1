Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbYJ3TS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbYJ3TS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 15:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbYJ3TSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 15:18:12 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34855 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759152AbYJ3TSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 15:18:11 -0400
Date: Thu, 30 Oct 2008 20:19:38 +0100
From: Pavel Machek <pavel@suse.cz>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] w35und: remove ->skb_array from struct wbsoft_priv
Message-ID: <20081030191938.GK22185@elf.ucw.cz>
References: <1225383127-16406-1-git-send-email-penberg@cs.helsinki.fi> <1225383127-16406-2-git-send-email-penberg@cs.helsinki.fi> <1225383127-16406-3-git-send-email-penberg@cs.helsinki.fi> <1225383127-16406-4-git-send-email-penberg@cs.helsinki.fi> <1225383127-16406-5-git-send-email-penberg@cs.helsinki.fi> <1225383127-16406-6-git-send-email-penberg@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225383127-16406-6-git-send-email-penberg@cs.helsinki.fi>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-10-30 18:12:06, Pekka Enberg wrote:
> It's not actually used for anything, so remove it.

Acked-by: Pavel Machek <pavel@suse.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
