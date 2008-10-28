Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbYJ1T3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbYJ1T3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 15:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbYJ1T3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 15:29:43 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43222 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbYJ1T3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 15:29:43 -0400
Date: Tue, 28 Oct 2008 20:31:17 +0100
From: Pavel Machek <pavel@suse.cz>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w35und: move supported band initialization out of
	wb35_probe()
Message-ID: <20081028193117.GH16452@elf.ucw.cz>
References: <Pine.LNX.4.64.0810280019330.9949@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810280019330.9949@melkki.cs.Helsinki.FI>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-10-28 00:20:03, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> This patch moves the static struct ieee80211_supported_band initialization out
> of w35_probe() because it's really global read-only configuration data.

Acked-by: Pavel Machek <pavel@suse.cz>


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
