Return-Path: <linux-kernel-owner+w=401wt.eu-S1757124AbZDVVO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124AbZDVVO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 17:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753675AbZDVVOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 17:14:50 -0400
Received: from smtp3.dnainternet.fi ([87.94.96.71]:10108 "EHLO
	smtp3.dnainternet.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140AbZDVVOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 17:14:49 -0400
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Apr 2009 17:14:48 EDT
X-Spam-Flag: NO
X-Spam-Score: 0
Message-ID: <20090423000820.82452fzhxxsz1c8w@hayate.sektori.org>
Date: Thu, 23 Apr 2009 00:08:20 +0300
From: "Jussi Kivilinna" <jussi.kivilinna@mbnet.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: Tree for April 22 (rndis_wlan)
References: <20090422154247.dbffd285.sfr@canb.auug.org.au>
	<49EF4B73.2050702@oracle.com> <20090422172804.GE3288@tuxdriver.com>
In-Reply-To: <20090422172804.GE3288@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting "John W. Linville" <linville@tuxdriver.com>:

>> # CONFIG_CFG80211 is not set
>
> No doubt this is the problem...
>
> ---
>
> From bce85c97aeeb9c34098951e9ef3de425c6830b63 Mon Sep 17 00:00:00 2001
> From: John W. Linville <linville@tuxdriver.com>
> Date: Wed, 22 Apr 2009 13:27:08 -0400
> Subject: [PATCH] rndis_wlan: select CFG80211 in Kconfig
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Acked-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>


