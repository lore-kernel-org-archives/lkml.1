Return-Path: <linux-kernel-owner+w=401wt.eu-S1757160AbZBZOAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160AbZBZOAH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:00:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbZBZN7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 08:59:51 -0500
Received: from mail.deathmatch.net ([70.167.247.36]:2799 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbZBZN7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 08:59:51 -0500
Date: Thu, 26 Feb 2009 08:59:39 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Message-ID: <20090226135938.GA12182@hash.localnet>
References: <20090222170201.GA27360@silver.sucs.org> <49A1CA01.9030501@gmail.com> <49A1DDD2.7040706@gmail.com> <20090223152724.M82409@bobcopeland.com> <49A321BA.2040500@gmail.com> <49A326A4.8090103@gmail.com> <40f31dec0902231508l512af5b7w68cfcc0bdf3cfa87@mail.gmail.com> <20090224135817.GB6019@hash.localnet> <49A46AD4.3060007@gmail.com> <20090225140139.GA18694@silver.sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225140139.GA18694@silver.sucs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 02:01:39PM +0000, Sitsofe Wheeler wrote:
> It has been days since the original BUG occurred and further it
> originally had happened in a -tip kernel with kmemcheck compiled into
> it. I had been utterly unable to reproduce the error on any network with
> a stock 2.6.29-rc6 kernel. Not even the original -tip kernel produced
> the error again...

Can you post your config?  I want to make sure I have all the same
knobs turned on, if I can think of a way to reproduce it.

-- 
Bob Copeland %% www.bobcopeland.com

