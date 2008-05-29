Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbYE2EwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbYE2EwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 00:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750714AbYE2Ev7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 00:51:59 -0400
Received: from namei.org ([69.55.235.186]:56789 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750709AbYE2Ev6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 00:51:58 -0400
Date: Thu, 29 May 2008 14:46:13 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       safford@watson.ibm.com, serue@linux.vnet.ibm.com, sailer@watson.ibm.com,
       zohar@us.ibm.com, Stephen Smalley <sds@tycho.nsa.gov>,
       CaseySchaufler <casey@schaufler-ca.com>
Subject: Re: [RFC][PATCH 4/5]integrity: Linux Integrity Module(LIM)
In-Reply-To: <1212029162.4747.27.camel@new-host.home>
Message-ID: <Xine.LNX.4.64.0805291443400.7754@us.intercode.com.au>
References: <1211555133.16195.17.camel@new-host> 
 <20080528004610.fde47571.akpm@linux-foundation.org> <1212029162.4747.27.camel@new-host.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2008, Mimi Zohar wrote:

> > Can we put the integrity_inode_init_integrity() call into
> > security_inode_init_security() thus avoiding having to change lots of
> > filesystems?
> 
> That is fine by me, not sure how others feel.

I agree it makes sense to do this.


-- 
James Morris
<jmorris@namei.org>
