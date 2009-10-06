Return-Path: <linux-kernel-owner+w=401wt.eu-S1757614AbZJFRjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614AbZJFRjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 13:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757291AbZJFRjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 13:39:54 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:38284 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757287AbZJFRjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 13:39:53 -0400
Date: Tue, 6 Oct 2009 10:29:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH trivial] docs: Describe the 'C' taint flag in
 oops-tracing.txt.
Message-Id: <20091006102957.e242d24b.randy.dunlap@oracle.com>
In-Reply-To: <20091006141222.GA18579@emergent.ellipticsemi.com>
References: <20091006141222.GA18579@emergent.ellipticsemi.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4ACB807F.00AD:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Oct 2009 10:12:22 -0400 Nick Bowler wrote:

> From: Nick Bowler <nbowler@elliptictech.com>
> 
> If some of the flags are documented there, they all should be.
> 
> Signed-off-by: Nick Bowler <nbowler@elliptictech.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> ---
>  Documentation/oops-tracing.txt |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/oops-tracing.txt b/Documentation/oops-tracing.txt
> index b152e81..c10c022 100644
> --- a/Documentation/oops-tracing.txt
> +++ b/Documentation/oops-tracing.txt
> @@ -257,6 +257,8 @@ characters, each representing a particular tainted value.
>  
>   10: 'W' if a warning has previously been issued by the kernel.
>  
> + 11: 'C' if a staging driver has been loaded.
> +
>  The primary reason for the 'Tainted: ' string is to tell kernel
>  debuggers if this is a clean kernel or if anything unusual has
>  occurred.  Tainting is permanent: even if an offending module is
> -- 


---
~Randy
