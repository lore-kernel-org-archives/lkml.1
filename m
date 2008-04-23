Return-Path: <linux-kernel-owner+w=401wt.eu-S1754775AbYDWEly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbYDWEly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 00:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbYDWElo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 00:41:44 -0400
Received: from ozlabs.org ([203.10.76.45]:42426 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbYDWEln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 00:41:43 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18446.48624.515912.541936@cargo.ozlabs.ibm.com>
Date: Wed, 23 Apr 2008 14:41:20 +1000
From: Paul Mackerras <paulus@samba.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Sam Ravnborg <sam@ravnborg.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [RFC patch 6/9] POWERPC remove -traditional
In-Reply-To: <20080422172842.427209743@polymtl.ca>
References: <20080422172404.502954084@polymtl.ca>
	<20080422172842.427209743@polymtl.ca>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers writes:
> Subject: [RFC patch 6/9] Re: [PATCH] Stringify support commas
>  > This is a no-no for those archs that still use -traditional.
>  > > I dunno if this is a problem for you at the moment and the
>  > > right fix is anyway to nuke -traditional.
>  > > 
>  > >     Sam
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: Sam Ravnborg <sam@ravnborg.org>
> CC: paulus@samba.org
> CC: linuxppc-dev@ozlabs.org
> ---
>  arch/powerpc/boot/Makefile |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Looks OK.  I'll put it in my tree.

Paul.
