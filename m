Return-Path: <linux-kernel-owner+w=401wt.eu-S1754477AbYJCRRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbYJCRRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 13:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbYJCRRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 13:17:13 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:37268 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbYJCRRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 13:17:11 -0400
Date: Fri, 3 Oct 2008 14:17:31 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Neil Brown <neilb@suse.de>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH 00/32] Swap over NFS - v19
Message-ID: <20081003141731.37bda8f3@doriath.conectiva>
In-Reply-To: <20081002130504.927878499@chello.nl>
References: <20081002130504.927878499@chello.nl>
Organization: Mandriva
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.3; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 02 Oct 2008 15:05:04 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> escreveu:

| Patches are against: v2.6.27-rc5-mm1
| 
| This release features more comments and (hopefully) better Changelogs.
| Also the netns stuff got sorted and ipv6 will now build and not oops
| on boot ;-)
| 
| The first 4 patches are cleanups and can go in if the respective maintainers
| agree.
| 
| The code is lightly tested but seems to work on my default config.
| 
| Let's get this ball rolling...

 What's the best way to test this? Create a swap in a NFS mount
point and stress it?

-- 
Luiz Fernando N. Capitulino
