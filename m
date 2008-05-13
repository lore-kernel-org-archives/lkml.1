Return-Path: <linux-kernel-owner+w=401wt.eu-S1759429AbYEMK3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429AbYEMK3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 06:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbYEMK31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 06:29:27 -0400
Received: from mail.lippert-at.com ([62.80.22.186]:27742 "EHLO
	domex.lippertembedded.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751716AbYEMK30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 06:29:26 -0400
Message-ID: <48296D83.3020007@LiPPERT-AT.de>
Date: Tue, 13 May 2008 12:29:23 +0200
From: Jens Rottmann <JRottmann@LiPPERT-AT.de>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Andres Salomon <dilinger@queued.net>
CC: jordan.crouse@amd.com, linux-kernel@vger.kernel.org,
       linux-geode@bombadil.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net, torvalds@linux-foundation.org
Subject: Re: lxfb driver regression
References: <20080507210836.1eb61b8f@ephemeral>	<48230694.5010505@LiPPERT-AT.de> <20080512185148.104fc4c3@ephemeral>
In-Reply-To: <20080512185148.104fc4c3@ephemeral>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 May 2008 10:29:49.0283 (UTC) FILETIME=[45927B30:01C8B4E4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> > Yes, of course that was my first idea, too. [...] But I'm
> > almost prepared to bet this is not the root of the evil.

Andres Salomon wrote:
> It works much better on an XO, so I've ack'd it.

Oops. Lucky I didn't bet, I'd have lost!
But it wasn't all fair, this strange fb resolution switch got me off track. ;-)


But it still surprises me that you get a white screen if you run the XO panel
with the specified frequency, and it only works as long as this is unavailable.
Are you sure the dotclock setting in olpc_dcon_modedb[] is correct?

Anyway, glad the problem is solved, now.

Again, many thanks for your help!
Jens
