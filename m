Return-Path: <linux-kernel-owner+w=401wt.eu-S1759151AbXKJEyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759151AbXKJEyl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 23:54:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbXKJEyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 23:54:33 -0500
Received: from namei.org ([69.55.235.186]:38415 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751592AbXKJEyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 23:54:33 -0500
Date: Sat, 10 Nov 2007 15:54:21 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Andrew Morton <akpm@linux-foundation.org>
cc: casey@schaufler-ca.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       method@manicmethod.com
Subject: Re: [PATCH 1/2]  NetLabel: Introduce a new kernel configuration API
 for NetLabel - Version 11 (2.6.24-rc2) Smack: Simplified Mandatory Access
 Control Kernel
In-Reply-To: <20071109165119.f40248b3.akpm@linux-foundation.org>
Message-ID: <Xine.LNX.4.64.0711101553330.28789@us.intercode.com.au>
References: <4733E6A3.2070307@schaufler-ca.com> <20071109165119.f40248b3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Nov 2007, Andrew Morton wrote:

> On Thu, 08 Nov 2007 20:48:35 -0800
> Casey Schaufler <casey@schaufler-ca.com> wrote:
> 
> > From: Paul Moore <paul.moore@hp.com>
> > 
> > Add a new set of configuration functions to the NetLabel/LSM API so that
> > LSMs can perform their own configuration of the NetLabel subsystem without
> > relying on assistance from userspace.
> > 
> > Signed-off-by: Paul Moore <paul.moore@hp.com>
> 
> You sent it, so this patch needs a Signed-off-by:you, please.

Also add

Reviewed-by: James Morris <jmorris@namei.org>


-- 
James Morris
<jmorris@namei.org>
