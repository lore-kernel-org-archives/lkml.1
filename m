Return-Path: <linux-kernel-owner+w=401wt.eu-S1754456AbZHLIP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbZHLIP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 04:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbZHLIP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 04:15:57 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48454 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020AbZHLIP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 04:15:56 -0400
Date: Wed, 12 Aug 2009 10:15:50 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] w35und: Remove some write-only struct members
Message-ID: <20090812081550.GG23832@elf.ucw.cz>
References: <1250064219-7372-1-git-send-email-penberg@cs.helsinki.fi> <1250064219-7372-2-git-send-email-penberg@cs.helsinki.fi> <1250064219-7372-3-git-send-email-penberg@cs.helsinki.fi> <1250064219-7372-4-git-send-email-penberg@cs.helsinki.fi> <1250064219-7372-5-git-send-email-penberg@cs.helsinki.fi> <1250064219-7372-6-git-send-email-penberg@cs.helsinki.fi> <1250064219-7372-7-git-send-email-penberg@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250064219-7372-7-git-send-email-penberg@cs.helsinki.fi>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-08-12 11:03:39, Pekka Enberg wrote:
> There's no point in keeping around struct members that are only written
> to but never read.
> 
> Cc: Pavel Machek <pavel@ucw.cz>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

ACK, but... Note I no longer have access to the hardware. It is
probably collecting dust in czech suse labs somewhere.

...and thanks!
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
