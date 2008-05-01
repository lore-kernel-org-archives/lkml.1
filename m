Return-Path: <linux-kernel-owner+w=401wt.eu-S1758588AbYEAD7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588AbYEAD7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 23:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754617AbYEAD7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 23:59:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:36269 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbYEAD7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 23:59:02 -0400
Cc: lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>, <Wei.Zhang@freescale.com>,
       torvalds@linux-foundation.org, mporter@kernel.crashing.org,
       benh@kernel.crashing.org, linuxppc-dev@ozlabs.org
Message-Id: <AC86E46C-F3D5-4197-9152-C1D257071B08@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <20080430164558.03b5f517.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH] rapidio: fix current kernel-doc notation
Date: Wed, 30 Apr 2008 22:57:14 -0500
References: <Pine.LNX.4.64.0804292009000.18219@shark.he.net> <20080430113500.dfe21880.akpm@linux-foundation.org> <51A34080-7981-4958-B225-4921FC95B84A@kernel.crashing.org> <20080430121239.28492328.akpm@linux-foundation.org> <18456.60948.463017.139935@cargo.ozlabs.ibm.com> <20080430151149.063920cf.randy.dunlap@oracle.com> <63DC9937-3C82-4744-8281-B9FDB941FEE1@kernel.crashing.org> <4818EFEC.4080003@oracle.com> <20080430164558.03b5f517.randy.dunlap@oracle.com>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 30, 2008, at 6:45 PM, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Fix current (-git16) missing docbook/kernel-doc notation in RapidIO  
> files.
>
> Warning(linux-2.6.25-git16//include/linux/rio.h:187): No description  
> found for parameter 'sys_size'
> Warning(linux-2.6.25-git16//include/linux/rio.h:187): No description  
> found for parameter 'phy_type'
>
> Warning(linux-2.6.25-git16//arch/powerpc/sysdev/fsl_rio.c:188): No  
> description found for parameter 'mport'
> Warning(linux-2.6.25-git16//arch/powerpc/sysdev/fsl_rio.c:224): No  
> description found for parameter 'mport'
> Warning(linux-2.6.25-git16//arch/powerpc/sysdev/fsl_rio.c:245): No  
> description found for parameter 'mport'
> Warning(linux-2.6.25-git16//arch/powerpc/sysdev/fsl_rio.c:270): No  
> description found for parameter 'mport'
> Warning(linux-2.6.25-git16//arch/powerpc/sysdev/fsl_rio.c:311): No  
> description found for parameter 'mport'
> Warning(linux-2.6.25-git16//arch/powerpc/sysdev/fsl_rio.c:996): No  
> description found for parameter 'dev'
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
> arch/powerpc/sysdev/fsl_rio.c |    9 +++++++--
> include/linux/rio.h           |    2 ++
> 2 files changed, 9 insertions(+), 2 deletions(-)

applied.

- k
