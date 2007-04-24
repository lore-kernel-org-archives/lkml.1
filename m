Return-Path: <linux-kernel-owner+w=401wt.eu-S1423034AbXDXTYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423034AbXDXTYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 15:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423050AbXDXTYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 15:24:32 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40637 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423034AbXDXTYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 15:24:31 -0400
Date: Tue, 24 Apr 2007 21:24:23 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Anton Vorontsov <cbou@mail.ru>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org
Subject: Re: [PATCH 6/7] ds2760 W1 slave
Message-ID: <20070424192423.GA16460@elf.ucw.cz>
References: <20070420120026.GF21752@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070420120026.GF21752@zarina>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> +#if 0
> +/* Code below works, but unused currently, thus produces "defined but not
> + * used" warning. It stays here for reference and future needs, feel free
> + * to drop "#if 0" when you're about to use it. */

We normaly don't do this.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
