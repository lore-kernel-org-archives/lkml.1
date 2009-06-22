Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbZFVRVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbZFVRVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 13:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbZFVRVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 13:21:15 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42451 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbZFVRVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 13:21:15 -0400
Date: Mon, 22 Jun 2009 19:21:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH] trivial: cleanup hpfall example code (checkpatch)
Message-ID: <20090622172113.GC21149@elf.ucw.cz>
References: <200906221108.37471.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906221108.37471.elendil@planet.nl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-06-22 11:08:36, Frans Pop wrote:
> This patch makes hpfall.c conform to kernel coding style.
> 
> I have not fixed the C99 // comments on two lines as they
> help indicate that those are not actually comments but
> incomplete code.
> 
> Before:
>  total: 10 errors, 6 warnings, 101 lines checked
> After:
>  total: 2 errors, 0 warnings, 99 lines checked
> 
> Signed-off-by: Frans Pop <elendil@planet.nl>

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
