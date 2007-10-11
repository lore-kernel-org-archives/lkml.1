Return-Path: <linux-kernel-owner+w=401wt.eu-S1763480AbXJQNMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763480AbXJQNMB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 09:12:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756767AbXJQNLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 09:11:53 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3767 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754428AbXJQNLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 09:11:52 -0400
Date: Thu, 11 Oct 2007 21:43:33 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Bhasker C V <bhasker@unixindia.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: CPU speed after hibernation
Message-ID: <20071011214333.GB4151@ucw.cz>
References: <1192171267.6631.8.camel@h1.unixindia.com> <200710121407.13024.rjw@sisk.pl> <1192203050.15112.1.camel@h1.unixindia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1192203050.15112.1.camel@h1.unixindia.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2007-10-12 21:00:50, Bhasker C V wrote:
> Hi all,
> 
>  False alarm. 
>  The cpu frequency works. But it takes a long time before it 
>  brings down the cpu speed. Initialy (atleast for 3-4 minutes) the 
>  CPU is kept at its high speed threshold and later the cpu throttling 
>  happens.

Strange.... do you know why? Some kind of userspace governor that
relies on load average?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
