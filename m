Return-Path: <linux-kernel-owner+w=401wt.eu-S1761401AbYCCVae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761401AbYCCVae (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:30:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbYCCVaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:30:24 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33007
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751342AbYCCVaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:30:23 -0500
Date: Mon, 03 Mar 2008 13:30:08 -0800 (PST)
Message-Id: <20080303.133008.100103952.davem@davemloft.net>
To: jmorris@namei.org
Cc: darwish.07@gmail.com, chrisw@sous-sol.org, sds@tycho.nsa.gov,
       eparis@parisplace.org, casey@schaufler-ca.com, dwmw2@infradead.org,
       paul.moore@hp.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-audit@redhat.com,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 4/9] Netlink: Use generic LSM hook
From: David Miller <davem@davemloft.net>
In-Reply-To: <Xine.LNX.4.64.0803040819410.8529@us.intercode.com.au>
References: <20080301194752.GA19636@ubuntu>
	<20080301195622.GE19636@ubuntu>
	<Xine.LNX.4.64.0803040819410.8529@us.intercode.com.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Morris <jmorris@namei.org>
Date: Tue, 4 Mar 2008 08:19:50 +1100 (EST)

> On Sat, 1 Mar 2008, Ahmed S. Darwish wrote:
> 
> > Don't use SELinux exported selinux_get_task_sid symbol. 
> > Use the generic LSM equivalent instead.
> > 
> > Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> > Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
> 
> Acked-by: James Morris <jmorris@namei.org>

Acked-by: David S. Miller <davem@davemloft.net>

I'll let the security folks merge this in.
