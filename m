Return-Path: <linux-kernel-owner+w=401wt.eu-S933637AbXCEVjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933637AbXCEVjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 16:39:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933644AbXCEVjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 16:39:00 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4532 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933637AbXCEViE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 16:38:04 -0500
Date: Tue, 1 Jan 2002 04:12:53 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Richard Purdie <rpurdie@openedhand.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-mtd@lists.infradead.org, dwmw2@infradead.org
Subject: Re: [PATCH 6/9] mtd: Add a 'block unused' ioctl call to provide hints to block drivers
Message-ID: <20020101041253.GC4106@ucw.cz>
References: <1172850894.11149.126.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1172850894.11149.126.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Knowing that the data in a given block is now unused is a useful
> feature that some block drivers can take advantage of, especially 
> when dealing with devices like flash.
> 
> This adds an ioctl which allows such hints to be passed to the

Maybe Documentation/ piece would be nice if this can be called from
userspace....

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
