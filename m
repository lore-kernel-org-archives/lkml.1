Return-Path: <linux-kernel-owner+w=401wt.eu-S1753090AbZIHAEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbZIHAEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 20:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbZIHAEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 20:04:31 -0400
Received: from tundra.namei.org ([65.99.196.166]:40130 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857AbZIHAEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 20:04:30 -0400
Date: Tue, 8 Sep 2009 10:03:43 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linux Filesystem Mailing List <linux-fsdevel@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 6/8] shmfs: use 'check_acl' instead of 'permission'
In-Reply-To: <alpine.LRH.2.00.0909080822400.11493@tundra.namei.org>
Message-ID: <alpine.LRH.2.00.0909081002490.12165@tundra.namei.org>
References: <alpine.LFD.2.01.0909071337510.3419@localhost.localdomain> <alpine.LFD.2.01.0909071401210.3419@localhost.localdomain> <alpine.LFD.2.01.0909071402220.3419@localhost.localdomain> <alpine.LFD.2.01.0909071402510.3419@localhost.localdomain>
 <alpine.LFD.2.01.0909071403110.3419@localhost.localdomain> <alpine.LFD.2.01.0909071403390.3419@localhost.localdomain> <alpine.LFD.2.01.0909071404090.3419@localhost.localdomain> <alpine.LRH.2.00.0909080822400.11493@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Sep 2009, James Morris wrote:

> Reviewed-by: James Morris <jmorris@namei.org>

Ditto for patches 7 & 8.


-- 
James Morris
<jmorris@namei.org>
