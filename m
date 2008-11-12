Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722AbYKLQtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbYKLQtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 11:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbYKLQtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 11:49:08 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1824 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbYKLQtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 11:49:07 -0500
Date: Wed, 12 Nov 2008 16:49:01 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power_supply: Add support for WM8350 PMU
Message-ID: <20081112164900.GJ8767@sirena.org.uk>
References: <1226416083-12875-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20081112164722.GB3882@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081112164722.GB3882@sortiz.org>
X-Cookie: /* Halley */
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 05:47:23PM +0100, Samuel Ortiz wrote:

> The MFD part looks good to me: 
> > Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Acked-by: Samuel Ortiz <sameo@openedhand.com>

I forgot to mention it on the repost (I did on the original) that since
this depends on the AUXADC support queued in the MFD tree it probably
makes sense to merge it via there.  Would you be OK with that if Anton
OKs the driver?
