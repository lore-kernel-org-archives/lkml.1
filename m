Return-Path: <linux-kernel-owner+w=401wt.eu-S1751984AbXLIMme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984AbXLIMme (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 07:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbXLIMm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 07:42:27 -0500
Received: from torres.zugschlus.de ([85.214.68.41]:56382 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbXLIMm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 07:42:26 -0500
Date: Sun, 9 Dec 2007 13:42:00 +0100
From: Marc Haber <mh+linux-kernel@zugschlus.de>
To: Matt Mackall <mpm@selenic.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Message-ID: <20071209124200.GA31147@torres.zugschlus.de>
References: <20071204114125.GA17310@torres.zugschlus.de> <20071204161811.GB15974@stusta.de> <20071204164720.6e4dc2c4@the-village.bc.nu> <475599D6.4030008@cosmosbay.com> <20071205212646.GP17536@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071205212646.GP17536@waste.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2007 at 03:26:47PM -0600, Matt Mackall wrote:
> The distinction between /dev/random and /dev/urandom boils down to one
> word: paranoia. If you are not paranoid enough to mistrust your
> network, then /dev/random IS NOT FOR YOU. Use /dev/urandom.

But currently, people who use /dev/urandom to obtain low-quality
entropy do a DoS for the paranoid people.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Mannheim, Germany  |  lose things."    Winona Ryder | Fon: *49 621 72739834
Nordisch by Nature |  How to make an American Quilt | Fax: *49 3221 2323190
