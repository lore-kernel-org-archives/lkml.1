Return-Path: <linux-kernel-owner+w=401wt.eu-S1755550AbYJ3T1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbYJ3T1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 15:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750768AbYJ3T1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 15:27:34 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:60219 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbYJ3T1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 15:27:34 -0400
Date: Thu, 30 Oct 2008 20:29:03 +0100
From: Pavel Machek <pavel@suse.cz>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] w35und: remove rxisr.c as dead code
Message-ID: <20081030192903.GM22185@elf.ucw.cz>
References: <1225386296-19632-1-git-send-email-penberg@cs.helsinki.fi> <1225386296-19632-2-git-send-email-penberg@cs.helsinki.fi> <1225386296-19632-3-git-send-email-penberg@cs.helsinki.fi> <1225386296-19632-4-git-send-email-penberg@cs.helsinki.fi> <1225386296-19632-5-git-send-email-penberg@cs.helsinki.fi> <1225386296-19632-6-git-send-email-penberg@cs.helsinki.fi> <1225386296-19632-7-git-send-email-penberg@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225386296-19632-7-git-send-email-penberg@cs.helsinki.fi>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-10-30 19:04:56, Pekka Enberg wrote:
> The vRxTimerStart() function is never called nor does the timer do anything
> useful so remove the code.

Whole series:

Acked-by: Pavel Machek <pavel@suse.cz>

...and thanks for doing that. The driver really needed it.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
