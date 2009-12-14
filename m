Return-Path: <linux-kernel-owner+w=401wt.eu-S1750916AbZLNFPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750916AbZLNFPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 00:15:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750816AbZLNFPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 00:15:13 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45598 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbZLNFPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 00:15:12 -0500
Date: Mon, 14 Dec 2009 06:15:03 +0100
From: Pavel Machek <pavel@ucw.cz>
To: re.emese@gmail.com
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org,
       torvalds@linux-foundation.org, linux@arm.linux.org.uk,
       akpm@linux-foundation.org
Subject: Re: [PATCH 00/10] Constify struct platform_suspend_ops for
 2.6.32-git-053fe57ac v2
Message-ID: <20091214051503.GF5114@elf.ucw.cz>
References: <cover.1260663003.git.re.emese@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1260663003.git.re.emese@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-12-14 01:00:16, re.emese@gmail.com wrote:
> From: Emese Revfy <re.emese@gmail.com>
> 
> Hello everyone!
> 
> The following patch series attempts to constify several structures
> that hold function pointers. This is only the initial batch, there
> are about over 150 candidate structures, some of which can be
> constified as well, I plan to submit them in the future.

I seem to get each mail twice, including the introduction one, with
different subject each time (and probably same message-id for
different mails).
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
