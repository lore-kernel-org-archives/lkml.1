Return-Path: <linux-kernel-owner+w=401wt.eu-S1760879AbYD0AkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760879AbYD0AkW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 20:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757285AbYD0AkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 20:40:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41517
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757077AbYD0AkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 20:40:08 -0400
Date: Sat, 26 Apr 2008 17:40:08 -0700 (PDT)
Message-Id: <20080426.174008.212982189.davem@davemloft.net>
To: kronos.it@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Fix compile error with wifi & leds
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080426203408.GA12074@dreamland.darkstar.lan>
References: <20080426203408.GA12074@dreamland.darkstar.lan>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luca Tettamanti <kronos.it@gmail.com>
Date: Sat, 26 Apr 2008 22:34:08 +0200

> Since MAC80211_LEDS is selected by wireless drivers it must select its
> own dependencies otherwise a build error may occur (kbuild will select
> the symbol regardless of "depends" constraints).
> 
> Signed-Off-By: Luca Tettamanti <kronos.it@gmail.com>

There are various ways to solve this problem, and I'll adopt one of
them, perhaps your's, over the weekend.

Thanks!
