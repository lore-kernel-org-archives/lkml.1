Return-Path: <linux-kernel-owner+w=401wt.eu-S932891AbXF2DEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932891AbXF2DEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 23:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932654AbXF2DEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 23:04:44 -0400
Received: from topsns2.toshiba-tops.co.jp ([202.230.225.126]:10861 "EHLO
	topsns2.toshiba-tops.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762915AbXF2DEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 23:04:43 -0400
Date: Fri, 29 Jun 2007 12:04:34 +0900 (JST)
Message-Id: <20070629.120434.130242230.nemoto@toshiba-tops.co.jp>
To: akpm@linux-foundation.org
Cc: a.zummo@towertech.it, linux-kernel@vger.kernel.org,
       rtc-linux@googlegroups.com, ab@mycable.de, mgreer@mvista.com,
       khali@linux-fr.org, david-b@pacbell.net
Subject: Re: [PATCH 1/2] rtc: add rtc-m41t80 driver
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20070625222142.e9215829.akpm@linux-foundation.org>
References: <20070625214620.6a48a02a.akpm@linux-foundation.org>
	<20070626.141536.126143027.nemoto@toshiba-tops.co.jp>
	<20070625222142.e9215829.akpm@linux-foundation.org>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2007 22:21:42 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:
> > Oh the variable should not be static!
> > I will send updated patch.
> 
> I'll fix it up.
...
> > Are you going back to "take 1" patches?  Why?
> 
> Stupidity, apparently.  Will restore the take2 patches.

Thanks.  I found another problem with these patches: I inserted
Kconfig entries at wrong place.  I will send take3 patches including
your fix.

---
Atsushi Nemoto
