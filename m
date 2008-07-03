Return-Path: <linux-kernel-owner+w=401wt.eu-S1757055AbYGCWsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055AbYGCWsK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 18:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755439AbYGCWr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 18:47:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755438AbYGCWr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 18:47:56 -0400
Date: Thu, 3 Jul 2008 15:47:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, debora@linux.vnet.ibm.com,
       zohar@linux.vnet.ibm.com
Subject: Re: [PATCH] Update MAINTAINERS file for the TPM device driver
Message-Id: <20080703154723.029d2948.akpm@linux-foundation.org>
In-Reply-To: <1214950956.2381.7.camel@blackbox>
References: <1214950956.2381.7.camel@blackbox>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Jul 2008 19:22:36 -0300
Rajiv Andrade <srajiv@linux.vnet.ibm.com> wrote:

> ___Update MAINTAINERS file for the TPM device driver.
> 
> Thanks,
> Rajiv Andrade
> IBM LTC Security Development
> 
> --
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8f0ec46..5f72839 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3995,7 +3995,8 @@ W:        http://www.buzzard.org.uk/toshiba/
>  S:     Maintained
> 
>  TPM DEVICE DRIVER
> -P:     Kylene Hall
> +P:     Debora Velarde
> +P:     Rajiv Andrade
>  M:     tpmdd-devel@lists.sourceforge.net
>  W:     http://tpmdd.sourceforge.net
>  P:     Marcel Selhorst
> 

Please always include a Signed-off-by: for kernel patches.  It seems
particularly relevant for patches which transfer maintainership.  Of a
security-related driver, no less.

