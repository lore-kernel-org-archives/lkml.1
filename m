Return-Path: <linux-kernel-owner+w=401wt.eu-S1761398AbXKNQqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761398AbXKNQqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 11:46:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758768AbXKNQqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 11:46:38 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:11430 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756698AbXKNQqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 11:46:37 -0500
Date: Wed, 14 Nov 2007 08:45:28 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: David Miller <davem@davemloft.net>, olof@lixom.net,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix warning for token-ring from sysctl checker
Message-Id: <20071114084528.0f092739.randy.dunlap@oracle.com>
In-Reply-To: <m1r6is253v.fsf@ebiederm.dsl.xmission.com>
References: <20071113072313.GB16842@lixom.net>
	<20071113.211540.97775009.davem@davemloft.net>
	<m1r6is253v.fsf@ebiederm.dsl.xmission.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2007 08:56:20 -0700 Eric W. Biederman wrote:

> David Miller <davem@davemloft.net> writes:
> 
> > From: Olof Johansson <olof@lixom.net>
> > Date: Tue, 13 Nov 2007 01:23:13 -0600
> >
> >> As seen when booting ppc64_defconfig:
> >> 
> >> sysctl table check failed: /net/token-ring .3.14 procname does not match
> > binary path procname
> >> 
> >> 
> >> Signed-off-by: Olof Johansson <olof@lixom.net>
> >
> > Patch applied, thanks Olof.
> 
> No objections but I think we already have this fixed in the -mm tree.

Yes, I patched it several weeks ago and it's been in -mm for a while
now.  Apparently too long.

---
~Randy
