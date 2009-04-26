Return-Path: <linux-kernel-owner+w=401wt.eu-S1753677AbZDZCBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677AbZDZCBf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 22:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbZDZCBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 22:01:25 -0400
Received: from mail.deathmatch.net ([72.66.92.28]:3681 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbZDZCBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 22:01:24 -0400
Date: Sat, 25 Apr 2009 22:00:47 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH 1/1] ath5k: 5211, don't crypt every protected frame
Message-ID: <20090426020047.GA10885@hash.localnet>
References: <1240661363-16631-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240661363-16631-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 25, 2009 at 02:09:23PM +0200, Jiri Slaby wrote:
> Hi guys,
> do you remember some 5211 HW which didn't work with this?
> --
> 
> Set null key type even on ar5211, otherwise it en/decrypts every frame with
> protected bit set which renders the card unusable on encrypted networks.

Not me.  I don't have the hardware, so I would say if your patch is known
to work on a 5211 then we go with it.

-- 
Bob Copeland %% www.bobcopeland.com

