Return-Path: <linux-kernel-owner+w=401wt.eu-S1760232AbZCTBvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760232AbZCTBvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 21:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575AbZCTBvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 21:51:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:63326 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbZCTBvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 21:51:06 -0400
Date: Thu, 19 Mar 2009 18:50:50 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Sachin Sant <sachinp@in.ibm.com>
cc: jfs-discussion@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>, shaggy@austin.ibm.com
Subject: Re: [Jfs-discussion] [BUG/JFS/2.6.29-rc8] kernel BUG at
 fs/mpage.c:473!
In-Reply-To: <49C1E736.1000508@in.ibm.com>
Message-ID: <alpine.DEB.2.01.0903191845100.16244@bogon.housecafe.de>
References: <49BDFB4F.7040405@in.ibm.com> <alpine.DEB.2.01.0903180259110.16244@bogon.housecafe.de> <49C1E736.1000508@in.ibm.com>
User-Agent: Alpine 2.01 (DEB 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX18hFerebFAqwmSoz3HVAdyZIbj7aEdf9YS64iN
 UFWH5T6uRZE9ngkVjLXrI6AbAfKIHXEse5oh/ZklgB1JiUZYpj
 Ok9DkqZMs+iuTsg7VXGNA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Mar 2009, Sachin Sant wrote:
> Yeah with default option values fsstress completes in a jiffy. I generally
> invoke fsstress with 1000 operations per process (-n 1000) and 1000
> processes (-p 1000).

Ah! I was curious if I could reproduce this on amd64 and started 
with 100, 1000, 10000 *iterations* (-l), will try with -n/-p now...

Thanks,
Christian.
-- 
My firewall cannot block www.schneier.com.
