Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbZHJBDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbZHJBDk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 21:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754256AbZHJBDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 21:03:39 -0400
Received: from tundra.namei.org ([65.99.196.166]:41193 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205AbZHJBDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 21:03:39 -0400
Date: Mon, 10 Aug 2009 11:03:25 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Eric Paris <eparis@redhat.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] security: define round_hint_to_min in !CONFIG_SECURITY
In-Reply-To: <1249671237.2694.11.camel@dhcp231-106.rdu.redhat.com>
Message-ID: <alpine.LRH.2.00.0908101103140.4396@tundra.namei.org>
References: <1249671237.2694.11.camel@dhcp231-106.rdu.redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Aug 2009, Eric Paris wrote:

> Fix the header files to define round_hint_to_min() and to define
> mmap_min_addr_handler() in the !CONFIG_SECURITY case.
> 
> Built and tested with !CONFIG_SECURITY
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
