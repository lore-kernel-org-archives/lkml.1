Return-Path: <linux-kernel-owner+w=401wt.eu-S1753610AbXC1Is3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbXC1Is3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 04:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbXC1Is3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 04:48:29 -0400
Received: from postman.ripe.net ([193.0.0.199]:51977 "EHLO postman.ripe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760AbXC1Is2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 04:48:28 -0400
Message-ID: <460A2BDB.6080200@ripe.net>
Date: Wed, 28 Mar 2007 10:48:27 +0200
From: Agoston Horvath <agoston@ripe.net>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: =?UTF-8?B?WU9TSElGVUpJIEhpZGVha2kgLyDlkInol6Toi7HmmI4=?= 
	<yoshfuji@linux-ipv6.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: IPv6: Connection reset/timeout under heavy load
References: <4608E7CA.3090001@ripe.net> <20070327.194636.63219035.yoshfuji@linux-ipv6.org>
In-Reply-To: <20070327.194636.63219035.yoshfuji@linux-ipv6.org>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-RIPE-Spam-Level: 
X-RIPE-Spam-Tests: ALL_TRUSTED,BAYES_00
X-RIPE-Spam-Status: N 0.152310 / -4.4
X-RIPE-Signature: 51d2a5d4e17e5bb2394eff6213466568
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

YOSHIFUJI Hideaki / 吉藤英明 wrote:
> Would you test with latest kernel, if possible, please?

For the archive: switching to 2.6.20.4 fixed this problem.

Thanks!

Agoston
