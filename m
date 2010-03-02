Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab0CBWWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 17:22:45 -0500
Received: from tundra.namei.org ([65.99.196.166]:60256 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067Ab0CBWWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 17:22:43 -0500
Date: Wed, 3 Mar 2010 09:22:42 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: wzt.wzt@gmail.com
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       sds@tycho.nsa.gov
Subject: Re: [PATCH] Selinux: Remove unused headers slab.h in
 selinux/ss/symtab.c
In-Reply-To: <20100302090343.GA12759@localhost.localdomain>
Message-ID: <alpine.LRH.2.00.1003030922240.14492@tundra.namei.org>
References: <20100302090343.GA12759@localhost.localdomain>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Mar 2010, wzt.wzt@gmail.com wrote:

> slab.h is unused in symtab.c, so remove it.
> 
> Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next-queue

-- 
James Morris
<jmorris@namei.org>
