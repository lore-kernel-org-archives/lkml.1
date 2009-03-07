Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbZCGEr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbZCGEr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 23:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbZCGErq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 23:47:46 -0500
Received: from mail.deathmatch.net ([70.167.247.36]:4045 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbZCGEro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 23:47:44 -0500
Date: Fri, 6 Mar 2009 23:47:32 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Message-ID: <20090307044732.GA13663@hash.localnet>
References: <40f31dec0902231508l512af5b7w68cfcc0bdf3cfa87@mail.gmail.com> <20090224135817.GB6019@hash.localnet> <49A46AD4.3060007@gmail.com> <20090225140139.GA18694@silver.sucs.org> <20090226135938.GA12182@hash.localnet> <20090226170338.GA1745@silver.sucs.org> <20090303041222.GA1238@hash.localnet> <20090303200352.GA8343@silver.sucs.org> <20090304120759.GA6519@hash.localnet> <20090306094249.GA10236@silver.sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090306094249.GA10236@silver.sucs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 09:42:49AM +0000, Sitsofe Wheeler wrote:
> Unfortunately I can't quite provide you what you were asking for... 

Well, this is great so far!  It'll take some time to dig through it
but it looks useful.

I saw _get_tsf64 in the trace; were you using ad-hoc/ibss mode, or 
is that just a weird artifact?

-- 
Bob Copeland %% www.bobcopeland.com

