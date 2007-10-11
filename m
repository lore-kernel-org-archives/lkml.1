Return-Path: <linux-kernel-owner+w=401wt.eu-S1756746AbXJKHLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746AbXJKHLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 03:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbXJKHLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 03:11:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280AbXJKHLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 03:11:13 -0400
Date: Thu, 11 Oct 2007 03:11:00 -0400
From: Dave Jones <davej@redhat.com>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mchehab@infradead.org,
       torvalds@linux-foundation.org, linux-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB changes for 2.6.24
Message-ID: <20071011071100.GA28382@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Markus Rechberger <mrechberger@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, mchehab@infradead.org,
	torvalds@linux-foundation.org, linux-dvb-maintainer@linuxtv.org,
	video4linux-list@redhat.com, linux-kernel@vger.kernel.org
References: <1192053794.15601.47.camel@gaivota> <d9def9db0710101600m79bd52e5s210d28630469b1c9@mail.gmail.com> <20071010163625.b4b438ec.akpm@linux-foundation.org> <d9def9db0710102209g1cc905a7w5565f1ecda720ea4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9def9db0710102209g1cc905a7w5565f1ecda720ea4@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2007 at 07:09:47AM +0200, Markus Rechberger wrote:
 
 > It makes no sense to keep the kernel driver uptodate, it would make
 > more sense to support the latest driver (which some people are
 > supporting).
 > I just had a look at the driver downloads it makes around 600
 > downloads for september for this driver.
 
600 downloads a month may seem like a lot to you for one driver.
But think about how many people are running distribution kernels
rather than kernels they built themselves.  Typically none of
these people will even know your driver exists, let alone go
running after it to download/build it.

>From an end-user perspective, out of tree drivers are a nuisance.
Time and time again, I get bug reports from users claiming
some bug is in the kernel, where the problem is actually that
they're running some out of tree driver that hasn't been 
updated to run on the latest kernels.

It's really in everyones (including yours) best interests
to get drivers merged into mainline.

	Dave

-- 
http://www.codemonkey.org.uk
