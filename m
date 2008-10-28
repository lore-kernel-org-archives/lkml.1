Return-Path: <linux-kernel-owner+w=401wt.eu-S1754023AbYJ1OxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbYJ1OxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 10:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbYJ1OxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 10:53:15 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:41663 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbYJ1OxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 10:53:14 -0400
Message-ID: <fa686aa40810280753lc555683y5d32da678384438@mail.gmail.com>
Date: Tue, 28 Oct 2008 08:53:11 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: avorontsov@ru.mvista.com
Subject: Re: [PATCH 1/4] of_gpio: Return GPIO flags from of_get_gpio()
Cc: "Trent Piepho" <tpiepho@freescale.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, "Richard Purdie" <rpurdie@rpsys.net>,
       "Sean MacLennan" <smaclennan@pikatech.com>,
       "Wolfram Sang" <w.sang@pengutronix.de>
In-Reply-To: <20081028143933.GA18453@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0810241442240.3790@t2.domain.actdsltmp>
	 <1224889741-4167-1-git-send-email-tpiepho@freescale.com>
	 <20081028143933.GA18453@oksana.dev.rtsoft.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 8:39 AM, Anton Vorontsov
<avorontsov@ru.mvista.com> wrote:
> Can you repost a fixed version with my Ack and Cc: Andrew Morton,
> Benjamin Herrenschmidt?
>
> I think this change should go into the 2.6.28, so that we can
> write new code on top of new API. Otherwise this change will cause
> issues in the next merge window.

While I like this series, it should not be pushed for .28.  The window
is closed and we are in bug-fix-only mode.  Focus on getting it into
Ben's -next tree instead.  That will deal with any merge window
conflicts.  I'd be happy to pull it through my 5200 tree when you post
the next version.

g.


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
