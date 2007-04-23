Return-Path: <linux-kernel-owner+w=401wt.eu-S1161155AbXDWSFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161155AbXDWSFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 14:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161205AbXDWSFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 14:05:36 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:52369 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161155AbXDWSFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 14:05:36 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Simon Horman <horms@verge.net.au>
Cc: kexec@lists.infradead.org, fastboot@lists.osdl.org,
       linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@in.ibm.com>,
       Haren Myneni <hbabu@us.ibm.com>
Subject: Re: Update the list information for kexec and kdump
References: <20070423083936.GI4272@verge.net.au>
Date: Mon, 23 Apr 2007 12:04:01 -0600
In-Reply-To: <20070423083936.GI4272@verge.net.au> (Simon Horman's message of
	"Mon, 23 Apr 2007 17:39:36 +0900")
Message-ID: <m13b2rvuge.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Horman <horms@verge.net.au> writes:

> Update the list information for kexec and kdump
>
> Signed-off-by: Simon Horman <horms@verge.net.au>
>
> --- 
> Is it too early for this change?

It looks like the new list is working, and isn't likely to get overwhelmed
with spam.  I don't know if everyone has switched over yet but we can
certainly update MAINTAINERS. 

Eric

> Index: linux-2.6/MAINTAINERS
> ===================================================================
> --- linux-2.6.orig/MAINTAINERS	2007-04-23 17:34:30.000000000 +0900
> +++ linux-2.6/MAINTAINERS	2007-04-23 17:34:47.000000000 +0900
> @@ -1951,7 +1951,7 @@ P:	Vivek Goyal
>  M:	vgoyal@in.ibm.com
>  P:	Haren Myneni
>  M:	hbabu@us.ibm.com
> -L:	fastboot@lists.osdl.org
> +L:	kexec@lists.infradead.org
>  L:	linux-kernel@vger.kernel.org
>  W:	http://lse.sourceforge.net/kdump/
>  S:	Maintained
> @@ -2001,7 +2001,7 @@ P:	Eric Biederman
>  M:	ebiederm@xmission.com
>  W:	http://www.xmission.com/~ebiederm/files/kexec/
>  L:	linux-kernel@vger.kernel.org
> -L:	fastboot@lists.osdl.org
> +L:	kexec@lists.infradead.org
>  S:	Maintained
>  
>  KPROBES
