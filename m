Return-Path: <linux-kernel-owner+w=401wt.eu-S1757958AbYKVAyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958AbYKVAyY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 19:54:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756608AbYKVAx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 19:53:56 -0500
Received: from mail.deathmatch.net ([70.167.247.36]:2184 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757615AbYKVAxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 19:53:55 -0500
Date: Fri, 21 Nov 2008 19:52:40 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: ipw3945-devel@lists.sourceforge.net, ath5k-devel@venema.h4ckr.net,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       wally@theblackmoor.net
Subject: Re: Unusually low speeds with ath5k and iwl3945
Message-ID: <20081122005240.GA27826@hash.localnet>
References: <492719ED.5000006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492719ED.5000006@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 10:28:29PM +0200, Maxim Levitsky wrote:
> I initially blamed iwl3945, then thought it got fixed, but now I have 
> ath5k, and speeds are low
> and I suspect that both drivers has bugs regarding to speed.

Quite possible, but both use mac80211 for rate control.  Which rate 
control algorithm are you using?  

-- 
Bob Copeland %% www.bobcopeland.com

