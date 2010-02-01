Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab0BAPGM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 10:06:12 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:62973 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab0BAPGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 10:06:10 -0500
Date: Mon, 1 Feb 2010 16:06:05 +0100
From: Heinz Diehl <htd@fancy-poultry.org>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       nhorman@tuxdriver.com, davem@davemloft.net
Subject: Re: [Bug #15196] kmem_cache_create: duplicate cache ccid2_h
Message-ID: <20100201150605.GA6175@fancy-poultry.org>
References: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera>
 <d3IDKWHT5gE.A.8sB.Q7hZLB@chimera>
 <7b6bb4a51001311930i7d72f60dj3b15ca3e1a715607@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b6bb4a51001311930i7d72f60dj3b15ca3e1a715607@mail.gmail.com>
X-Accept-Language: no,dk,se,en,de
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.20+20100131 (GNU/Linux)
X-Provags-ID: V01U2FsdGVkX18FxWLfZJZePrZgYnmqA46pL8drwYcuh8QZ8zn
 KtK2LLgqWdrEJ0Cy27adA/QPn253XU2Sl9lLJzN4B2/8mp9Hvq
 BWuJMILIjT3VouSFFNmEQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.02.2010, Xiaotian Feng wrote: 

> Does following patch resolve this bug, Heinz?
[....]

The patch was completely malformed, don't know what happened on the way,
but I applied it by hand. Yes, it fixes the problem for me.

Thanks,
Heinz.
