Return-Path: <linux-kernel-owner+w=401wt.eu-S1758751AbXFZWpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751AbXFZWpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 18:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbXFZWpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 18:45:38 -0400
Received: from waste.org ([66.93.16.53]:33344 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170AbXFZWph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 18:45:37 -0400
Date: Tue, 26 Jun 2007 17:45:18 -0500
From: Matt Mackall <mpm@selenic.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC #2] hwrng: Add type categories
Message-ID: <20070626224517.GG11115@waste.org>
References: <200706262021.51410.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706262021.51410.mb@bu3sch.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 08:21:51PM +0200, Michael Buesch wrote:
> Don't use the word "quality", as people seem to think of
> the entropy quality when hearing that word.

Why do I so often feel compelled to respond with "did you read what I
wrote?" on this list?

I object to your MEANINGLESS CATEGORIES.

> This uses the word "type", which is probably better for
> understanding what the value really means.

Please explain:

a) how is bad different from pseudo?
b) how is onboard different than dedicated?

I maintain that there are exactly two categories on this axis: real
and fake. And I'd rather stomp all over this notion of other
categories you've invented now before people actually start trying to
use them.

There are also two other axes that this approach neglects. Trusted
(another boolean) and bitrate (a scalar).

-- 
Mathematics is the supreme nostalgia of our time.
