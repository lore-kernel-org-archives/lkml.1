Return-Path: <linux-kernel-owner+w=401wt.eu-S1754609AbZEUKsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbZEUKsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 06:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbZEUKsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 06:48:11 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40705 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbZEUKsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 06:48:10 -0400
Date: Thu, 21 May 2009 12:48:05 +0200
From: Pavel Machek <pavel@ucw.cz>
To: =?iso-8859-1?Q?=C9ric?= Piel <eric.piel@tremplin-utc.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] lis3: fix misc device unregistering and printk
Message-ID: <20090521104805.GA2637@elf.ucw.cz>
References: <4A151E9F.1080405@tremplin-utc.net> <4A151F0A.9070405@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A151F0A.9070405@tremplin-utc.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-05-21 11:29:46, Éric Piel wrote:
> 
> Can only unregister the misc device if it was registered before. Also
> remove debugging messages, which in addition were not properly formated.
> 
> Signed-off-by: Éric Piel <eric.piel@tremplin-utc.net>

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
