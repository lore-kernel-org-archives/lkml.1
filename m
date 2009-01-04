Return-Path: <linux-kernel-owner+w=401wt.eu-S1760474AbZADUIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760474AbZADUIl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 15:08:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbZADUId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 15:08:33 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58325 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbZADUIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 15:08:32 -0500
Date: Sun, 4 Jan 2009 21:10:25 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Alexander E. Patrakov" <patrakov@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       tytso@mit.edu, mtk.manpages@gmail.com, rdunlap@xenotime.net,
       linux-doc@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: document ext3 requirements
Message-ID: <20090104201025.GB20375@elf.ucw.cz>
References: <20090103123813.GA1512@ucw.cz> <4960BB2D.3060000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4960BB2D.3060000@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-01-04 18:35:41, Alexander E. Patrakov wrote:
> Pavel Machek wrote:
> [CC: Alan Cox because of his reply in the "XFS internal error" thread]
>
>> Using ext3 is only safe if storage subsystem meets certain
>> criteria. Document those.
>
> Thanks for this patch. However, after reading this, I have a stupid  
> question: which file system should I use if I had to reinstall my  
> computers from scratch now?

ext2 is still the safest default... if you can live with fsck.

ext3 is the safest from the journalling ones, AFAICT.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
