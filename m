Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbZCJITm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbZCJITm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 04:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbZCJITX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 04:19:23 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:42823 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbZCJITW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 04:19:22 -0400
Date: Tue, 10 Mar 2009 08:19:16 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Message-ID: <20090310081916.GA11924@silver.sucs.org>
References: <20090225140139.GA18694@silver.sucs.org> <20090226135938.GA12182@hash.localnet> <20090226170338.GA1745@silver.sucs.org> <20090303041222.GA1238@hash.localnet> <20090303200352.GA8343@silver.sucs.org> <20090304120759.GA6519@hash.localnet> <20090306094249.GA10236@silver.sucs.org> <20090308030928.GB14966@hash.localnet> <49B38FB7.3000002@gmail.com> <20090310004344.GA23466@hash.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090310004344.GA23466@hash.localnet>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 08:43:44PM -0400, Bob Copeland wrote:
> Ok, here's a patch, it survived a few hours of testing with 3 rx buffers.
> Sitsofe, it's worth a try applying this one, even though it probably
> isn't it :)

Understood. It could be a few days before I can back to you as to
whether it had an effect though.

-- 
Sitsofe | http://sucs.org/~sits/
