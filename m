Return-Path: <linux-kernel-owner+w=401wt.eu-S1754441AbXKUVgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbXKUVgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 16:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbXKUVgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 16:36:11 -0500
Received: from namei.org ([69.55.235.186]:47931 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751780AbXKUVgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 16:36:10 -0500
Date: Thu, 22 Nov 2007 08:35:06 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Stephen Smalley <sds@tycho.nsa.gov>
cc: Christoph Hellwig <hch@infradead.org>, Alexey Dobriyan <adobriyan@sw.ru>,
       akpm@osdl.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       devel@openvz.org, Eric Paris <eparis@parisplace.org>
Subject: Re: [patch 1/1] selinux:  do not clear f_op when removing entries
In-Reply-To: <1195653696.759.29.camel@moss-spartans.epoch.ncsc.mil>
Message-ID: <Xine.LNX.4.64.0711220834300.12736@us.intercode.com.au>
References: <20071116150651.GC19517@localhost.sw.ru>  <20071119125139.GB15942@infradead.org>
  <1195571105.20910.31.camel@moss-spartans.epoch.ncsc.mil> 
 <20071120151731.GA20322@infradead.org> <1195653696.759.29.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007, Stephen Smalley wrote:

> Do not clear f_op when removing entries since it isn't safe to do.
> 
> Signed-off-by:  Stephen Smalley <sds@tycho.nsa.gov>

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/selinux-2.6.git#for-akpm


-- 
James Morris
<jmorris@namei.org>
