Return-Path: <linux-kernel-owner+w=401wt.eu-S1755763AbZEXUzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763AbZEXUzF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 16:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbZEXUyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 16:54:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43881 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbZEXUyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 16:54:55 -0400
Date: Sun, 24 May 2009 22:54:50 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux PM List <linux-pm@lists.linux-foundation.org>
Subject: Re: 2 bugs related to suspend to disk
Message-ID: <20090524205450.GA1693@elf.ucw.cz>
References: <4A199A7A.3010705@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A199A7A.3010705@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> 2) "s2disk" (from suspend-0.8) suspends, but doesn't resume (and I need to mkswap && swapon -a later)
>

I'm afraid we need more details here. Is "resume" binary being ran?
Does it produce some output?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
