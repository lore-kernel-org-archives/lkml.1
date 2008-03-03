Return-Path: <linux-kernel-owner+w=401wt.eu-S1762989AbYCCVVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762989AbYCCVVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:21:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762330AbYCCVUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:20:49 -0500
Received: from namei.org ([69.55.235.186]:42053 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762172AbYCCVUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:20:47 -0500
Date: Tue, 4 Mar 2008 08:19:08 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
cc: Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       David Woodhouse <dwmw2@infradead.org>, Paul Moore <paul.moore@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Audit-ML <linux-audit@redhat.com>,
       LSM-ML <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 2/9] SELinux: setup new inode/ipc getsecid hooks
In-Reply-To: <20080301195230.GC19636@ubuntu>
Message-ID: <Xine.LNX.4.64.0803040818580.8529@us.intercode.com.au>
References: <20080301194752.GA19636@ubuntu> <20080301195230.GC19636@ubuntu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Mar 2008, Ahmed S. Darwish wrote:

> Setup the new inode_getsecid and ipc_getsecid() LSM hooks
> for SELinux.
> 
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>

Acked-by: James Morris <jmorris@namei.org>

> 

-- 
James Morris
<jmorris@namei.org>
