Return-Path: <linux-kernel-owner+w=401wt.eu-S1758670AbXG3Ma6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670AbXG3Ma6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 08:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbXG3Mas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 08:30:48 -0400
Received: from stinky.trash.net ([213.144.137.162]:36244 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbXG3Mar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 08:30:47 -0400
Message-ID: <46ADD9E5.3050104@trash.net>
Date: Mon, 30 Jul 2007 14:30:29 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>,
       netfilter-devel@lists.netfilter.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make nf_ct_ipv6_skip_exthdr() static
References: <20070729145846.GZ16817@stusta.de>
In-Reply-To: <20070729145846.GZ16817@stusta.de>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> nf_ct_ipv6_skip_exthdr() can now become static.


Applied, thanks.
