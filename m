Return-Path: <linux-kernel-owner+w=401wt.eu-S1755071AbZFVIzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbZFVIzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 04:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751660AbZFVIzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 04:55:31 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:55831 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbZFVIza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 04:55:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=n8s63hRFs8/Ozkpo67jQ25QJar0c0tJKvA+kJGNSi1MHurcz8zeWTFyo2upLp2Yj98
         3koeNjrQ06C2m/mBzjVqVibh1gSrooXCkiZxCms34vNuYtVnEOEwUoToH/aQ751q15E4
         zUTlbWN85X6qxXQrK2++DfrOHadd5/ZRGFuFc=
Date: Mon, 22 Jun 2009 16:57:35 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Paul Menage <menage@google.com>,
       akpm@linux-foundation.org, jdike@addtoit.com,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH] UML: Fix some apparent bitrot
Message-ID: <20090622085735.GB6499@cr0.nay.redhat.com>
References: <20090620005524.25582.69677.stgit@menage.mtv.corp.google.com> <4A3F4448.30502@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A3F4448.30502@panasas.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 11:43:52AM +0300, Boaz Harrosh wrote:
>
>Stephan hi.
>
>The above breakage is the usual stuff we get every merge window. With people doing
>cross arch work and neglecting UML.
>
>Who is the person or people responsible for the large linux-next compilation rig?
>Is it possible to also add a UML traget, at least for the x86_64/x86_32 sub-arch?

Agreed.

Stephan, could you please also do compiling tests for UML in your -next tree?

Thanks!
