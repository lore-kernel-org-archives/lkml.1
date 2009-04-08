Return-Path: <linux-kernel-owner+w=401wt.eu-S1758921AbZDHKBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921AbZDHKBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 06:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757886AbZDHKBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 06:01:01 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57396 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbZDHKBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 06:01:00 -0400
Date: Wed, 8 Apr 2009 12:03:58 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] w35und: merge rest of wbhal.c to phy_calibration.c
Message-ID: <20090408100358.GD24848@elf.ucw.cz>
References: <1239180682-22860-1-git-send-email-penberg@cs.helsinki.fi> <1239180682-22860-4-git-send-email-penberg@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239180682-22860-4-git-send-email-penberg@cs.helsinki.fi>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-04-08 11:51:22, Pekka Enberg wrote:
> Impact: cleanup
> 
> The remaining functions are local to phy_calibration.c so move them
> there and remove wbhal.c.
> 

Whole series looks ok to me. 

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
