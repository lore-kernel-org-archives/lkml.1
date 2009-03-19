Return-Path: <linux-kernel-owner+w=401wt.eu-S1757263AbZCSXec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263AbZCSXec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 19:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757247AbZCSXeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 19:34:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754821AbZCSXeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 19:34:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
X-Fcc: ~/Mail/linus
Cc: peterz@infradead.org, efault@gmx.de, rjw@sisk.pl, jdike@addtoit.com,
       mingo@elte.hu, Oleg Nesterov <oleg@redhat.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] fix uml slowness caused by ptrace preemption bug on host
In-Reply-To: Miklos Szeredi's message of  Thursday, 19 March 2009 23:23:50 +0100 <E1LkQeU-00020Z-Be@pomaz-ex.szeredi.hu>
References: <E1LkQeU-00020Z-Be@pomaz-ex.szeredi.hu>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20090319233311.8B26BFC381@magilla.sf.frob.com>
Date: Thu, 19 Mar 2009 16:33:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm no scheduler expert and I don't know whether the exact placement in
your change is the optimal one.  But it's certainly fine from a ptrace
perspective.


Thanks,
Roland
