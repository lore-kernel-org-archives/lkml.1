Return-Path: <linux-kernel-owner+w=401wt.eu-S1758827AbYJ3TRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758827AbYJ3TRo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 15:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbYJ3TRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 15:17:31 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34853 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbYJ3TRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 15:17:30 -0400
Date: Thu, 30 Oct 2008 20:19:00 +0100
From: Pavel Machek <pavel@suse.cz>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] w35und: move packet_came() to wb35rx.c
Message-ID: <20081030191900.GJ22185@elf.ucw.cz>
References: <1225383127-16406-1-git-send-email-penberg@cs.helsinki.fi> <1225383127-16406-2-git-send-email-penberg@cs.helsinki.fi> <1225383127-16406-3-git-send-email-penberg@cs.helsinki.fi> <1225383127-16406-4-git-send-email-penberg@cs.helsinki.fi> <1225383127-16406-5-git-send-email-penberg@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225383127-16406-5-git-send-email-penberg@cs.helsinki.fi>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-10-30 18:12:05, Pekka Enberg wrote:
> The function no longer has dependencies to wbusb.c so we can move it to
> wb35rx.c and make it static now.

Acked-by: Pavel Machek <pavel@suse.cz>


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
