Return-Path: <linux-kernel-owner+w=401wt.eu-S1751708AbZJCEvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbZJCEvi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 00:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbZJCEvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 00:51:37 -0400
Received: from smtp.wp.pl ([212.77.101.1]:8371 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751327AbZJCEvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 00:51:36 -0400
Date: Sat, 3 Oct 2009 07:08:04 +0200
From: Krzysztof Helt <krzysztof.h1@wp.pl>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
       Pavel Kiryukhin <pkiryukhin@ru.mvista.com>,
       Steve Chen <schen@mvista.com>,
       Sudhakar Rajashekhara <sudhakar.raj@ti.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       davinci <davinci-linux-open-source@linux.davincidsp.com>,
       linux-fbdev-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] video: includecheck fix: da8xx-fb.c
Message-Id: <20091003070804.68abad29.krzysztof.h1@wp.pl>
In-Reply-To: <1253790430.5860.11.camel@ht.satnam>
References: <1253790430.5860.11.camel@ht.satnam>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [cWMk]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Sep 2009 16:37:10 +0530
Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> 
> fix the following 'make includecheck' warning:
> 
>   drivers/video/da8xx-fb.c: linux/device.h is included more than once.
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Cc: Kevin Hilman <khilman@deeprootsystems.com>
> Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
> Cc: Pavel Kiryukhin <pkiryukhin@ru.mvista.com>
> Cc: Steve Chen <schen@mvista.com>
> Cc: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  drivers/video/da8xx-fb.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 

Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
