Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab0AOJ14 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 04:27:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755705Ab0AOJ1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 04:27:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36911
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753722Ab0AOJ1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 04:27:54 -0500
Date: Fri, 15 Jan 2010 01:28:03 -0800 (PST)
Message-Id: <20100115.012803.118035218.davem@davemloft.net>
To: roel.kluin@gmail.com
Cc: maz@misterjones.org, sparclinux@vger.kernel.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc: leds_resource.end assigned to itself in
 clock_board_probe()
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B4F762A.20605@gmail.com>
References: <4B4F4C9B.9040202@gmail.com>
	<20100114183054.0b53c351@taxman.wild-wind.fr.eu.org>
	<4B4F762A.20605@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>
Date: Thu, 14 Jan 2010 20:53:14 +0100

> It should be a 1 byte region.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Yes, that was the intention.

Applied, thanks Roel!
