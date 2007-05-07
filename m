Return-Path: <linux-kernel-owner+w=401wt.eu-S966743AbXEGUiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966743AbXEGUiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966737AbXEGUiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:38:19 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34883 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966735AbXEGUiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:38:18 -0400
Date: Mon, 7 May 2007 22:38:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Anton Vorontsov <cbou@mail.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 8/8] One Laptop Per Child power/battery driver
Message-ID: <20070507203812.GA18400@elf.ucw.cz>
References: <20070503213303.GH20067@zarina> <20070507140453.GD3868@ucw.cz> <1178550653.11851.191.camel@pmac.infradead.org> <20070507194949.GB3981@ucw.cz> <1178567497.11851.229.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178567497.11851.229.camel@pmac.infradead.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2007-05-07 20:51:37, David Woodhouse wrote:
> On Mon, 2007-05-07 at 19:49 +0000, Pavel Machek wrote:
> > We had this discussion before. Kernel sources should be us-ascii.
> > utf-8 is ok for documentation. 
> 
> /* This _is_ documentation. Go away. */

No, that's a comment. Fix your code.

(And besides, comments are supposed to be useful. Patch contained
something like...

int voltage; /* ??V */

...which is pretty unhelpful. We still stick to 80 columns in the
code, and bigger displays certainly predate utf-8 compatibility. Plus,
you'd have to convert large part of Czech republic before I could
reasonably use utf-8).
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
