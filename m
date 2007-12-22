Return-Path: <linux-kernel-owner+w=401wt.eu-S1760620AbXLVA1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760620AbXLVA1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 19:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753583AbXLVA1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 19:27:43 -0500
Received: from namei.org ([69.55.235.186]:50061 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755442AbXLVA1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 19:27:42 -0500
Date: Sat, 22 Dec 2007 11:27:02 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Richard Knutsson <ricknu-0@student.ltu.se>
cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mmap: Remove sparse-warning (NULL as 0).
In-Reply-To: <20071208110455.20540.86240.sendpatchset@thinktank.campus.ltu.se>
Message-ID: <Xine.LNX.4.64.0712221126380.29009@us.intercode.com.au>
References: <20071208110455.20540.86240.sendpatchset@thinktank.campus.ltu.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Dec 2007, Richard Knutsson wrote:

> Fixing:
>   CHECK   mm/mmap.c
> mm/mmap.c:1623:29: warning: Using plain integer as NULL pointer
> mm/mmap.c:1623:29: warning: Using plain integer as NULL pointer
> mm/mmap.c:1944:29: warning: Using plain integer as NULL pointer
> 
> Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
> ---
> Added by: 8869477a49c3e99def1fcdadd6bbc407fea14b45 (Linus' tree)
> Compile-tested on i386 with all[yes|mod|no]config.

Thanks, applied to

git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/selinux-2.6.git#for-akpm



- James
-- 
James Morris
<jmorris@namei.org>
