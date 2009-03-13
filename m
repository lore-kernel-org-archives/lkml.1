Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025AbZCMM3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbZCMM3I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 08:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbZCMM2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 08:28:55 -0400
Received: from static-72-66-92-28.washdc.fios.verizon.net ([72.66.92.28]:3817
	"EHLO mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbZCMM2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 08:28:54 -0400
Date: Fri, 13 Mar 2009 08:28:47 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Message-ID: <20090313122847.GB23466@hash.localnet>
References: <20090226170338.GA1745@silver.sucs.org> <20090303041222.GA1238@hash.localnet> <20090303200352.GA8343@silver.sucs.org> <20090304120759.GA6519@hash.localnet> <20090306094249.GA10236@silver.sucs.org> <20090308030928.GB14966@hash.localnet> <49B38FB7.3000002@gmail.com> <20090310004344.GA23466@hash.localnet> <20090312061047.GA13401@silver.sucs.org> <20090313095213.GA14250@silver.sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090313095213.GA14250@silver.sucs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 13, 2009 at 09:52:13AM +0000, Sitsofe Wheeler wrote:
> The dmesg and trace can be found on
> http://sucs.org/~sits/test/eeepc-debug/20090313/ .
> 
> The one I'll note is that every time this issue has occurred I've been
> connected to encrypted networks (both WPA and WEP).

Awesome, thanks for the great debugging help!

-- 
Bob Copeland %% www.bobcopeland.com

