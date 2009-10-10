Return-Path: <linux-kernel-owner+w=401wt.eu-S1758817AbZJJMPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817AbZJJMPt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 08:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758268AbZJJMPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 08:15:48 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57289 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758104AbZJJMPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 08:15:47 -0400
Date: Sat, 10 Oct 2009 14:15:04 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] PM / Hibernate: swap, use KERN_CONT
Message-ID: <20091010121504.GB1943@ucw.cz>
References: <1255176024-12420-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255176024-12420-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-10-10 14:00:24, Jiri Slaby wrote:
> Use KERN_CONT in save_image for printks. So that anybody won't
> try to add a loglevel.

Someone has a big, pending patch to switch to pr_*. Should we take
that instead?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
