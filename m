Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab0CCV61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 16:58:27 -0500
Received: from tundra.namei.org ([65.99.196.166]:35495 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756811Ab0CCV6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 16:58:21 -0500
Date: Thu, 4 Mar 2010 08:58:20 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: wzt.wzt@gmail.com
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Selinux: Remove unused headers skbuff.h in
 selinux/nlmsgtab.c
In-Reply-To: <20100303132937.GB2716@localhost.localdomain>
Message-ID: <alpine.LRH.2.00.1003040857170.28385@tundra.namei.org>
References: <20100303132937.GB2716@localhost.localdomain>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Mar 2010, wzt.wzt@gmail.com wrote:

> skbuff.h is already included by netlink.h, so remove it.
> 
> Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next-queue


FWIW, next-queue is where patches are being queued until Linus releases 
-rc1, as Stephen Rothwell has asked not to put new code into -next until 
then.

-- 
James Morris
<jmorris@namei.org>
