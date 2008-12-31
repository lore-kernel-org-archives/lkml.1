Return-Path: <linux-kernel-owner+w=401wt.eu-S1756389AbYLaOD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbYLaOD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 09:03:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755157AbYLaODu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 09:03:50 -0500
Received: from mail.deathmatch.net ([70.167.247.36]:3457 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbYLaODu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 09:03:50 -0500
Date: Wed, 31 Dec 2008 09:03:08 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Andreas Mohr <andi@lisas.de>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, ath5k-devel@venema.h4ckr.net,
       linux-kernel@vger.kernel.org
Subject: Re: [ath5k-devel] Bugs on aspire one A150
Message-ID: <20081231140308.GA26600@hash.localnet>
References: <1230641016.5770.5.camel@maxim-laptop> <20081231091845.GA2516@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081231091845.GA2516@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2008 at 10:18:45AM +0100, Andreas Mohr wrote:
> Hi,
> 
> > Sure, will test, I am also sure that this will work.
> 
> A110L, 2.6.28, success (also inverted here, traffic blanks it).

Thanks for testing.

By inverted, do you mean that it is off when it should be on and
vice-versa?  If so, you can change it to 'sc->led_on = 0' instead
of 1.  Let me know if I should make that change in the patch.

-- 
Bob Copeland %% www.bobcopeland.com

