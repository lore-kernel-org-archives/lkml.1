Return-Path: <linux-kernel-owner+w=401wt.eu-S1756074AbZF0DQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbZF0DQ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 23:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbZF0DQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 23:16:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56542 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbZF0DQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 23:16:15 -0400
Date: Fri, 26 Jun 2009 20:15:57 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Jesper Dangaard Brouer <hawk@diku.dk>
cc: David Miller <davem@davemloft.net>, Jesper Dangaard Brouer <jdb@comx.dk>,
       paulmck@linux.vnet.ibm.com, netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Patrick McHardy <kaber@trash.net>,
       yoshfuji@linux-ipv6.org, linux-nfs@vger.kernel.org,
       linux-ext4@vger.kernel.org, catalin.marinas@gmail.com
Subject: Re: [PATCH 07/10] decnet: Use rcu_barrier() on module unload.
In-Reply-To: <Pine.LNX.4.64.0906262100210.14848@ask.diku.dk>
Message-ID: <alpine.DEB.2.01.0906262010091.6439@bogon>
References: <1245845367.24921.3.camel@localhost.localdomain> <5A680E0A-EFEB-44EA-9F06-F338E6CBD6D1@googlemail.com> <1245930729.24921.67.camel@localhost.localdomain> <20090625.161046.19938291.davem@davemloft.net>
 <Pine.LNX.4.64.0906262100210.14848@ask.diku.dk>
User-Agent: Alpine 2.01 (DEB 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX193TVNMJDRkntaOy69F9GM9bKmT7E+E5rUkFjT
 OEhuRM0l8YjrlH3SSf3gI0bIYDPZ+jtigpjnVzojbWeE7UMOFJ
 7cw0Kc4j8EyubqJLsGVWA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jun 2009, Jesper Dangaard Brouer wrote:
> I'll resubmit the patches to you and netdev, to limit the spam effect...

Out of curiosity: why was linux-ext4 Cc'ed on these rcu_barrier patches
(but not other fs-lists but linux-nfs)? I did not see any ../fs/ext4/ 
changes.

Christian.
-- 
BOFH excuse #6:

global warming
