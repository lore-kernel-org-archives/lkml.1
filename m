Return-Path: <linux-kernel-owner+w=401wt.eu-S1755298AbZAVRPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbZAVRPZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 12:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757036AbZAVROz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 12:14:55 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:61167 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756889AbZAVROy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 12:14:54 -0500
Message-ID: <4978A980.4040405@oracle.com>
Date: Thu, 22 Jan 2009 09:14:40 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
Subject: Re: linux-next: Tree for January 22 (staging/altpcichdma)
References: <20090122180543.1ab0baa6.sfr@canb.auug.org.au>
In-Reply-To: <20090122180543.1ab0baa6.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010204.4978A983.012D:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090121:


drivers/staging/altpciechdma/altpciechdma.c: In function 'ape_sg_to_chdma_table':
drivers/staging/altpciechdma/altpciechdma.c:429: warning: format '%08x' expects type 'unsigned int', but argument 3 has type 'dma_addr_t'
drivers/staging/altpciechdma/altpciechdma.c:433: warning: format '%08x' expects type 'unsigned int', but argument 3 has type 'dma_addr_t'
drivers/staging/altpciechdma/altpciechdma.c:449: warning: format '%08x' expects type 'unsigned int', but argument 3 has type 'dma_addr_t'
drivers/staging/altpciechdma/altpciechdma.c:450: warning: format '%08x' expects type 'unsigned int', but argument 3 has type 'dma_addr_t'
drivers/staging/altpciechdma/altpciechdma.c: In function 'dma_test':
drivers/staging/altpciechdma/altpciechdma.c:547: warning: assignment makes integer from pointer without a cast
drivers/staging/altpciechdma/altpciechdma.c: In function 'probe':
drivers/staging/altpciechdma/altpciechdma.c:930: warning: label 'err_rev' defined but not used
drivers/staging/altpciechdma/altpciechdma.c:913: warning: label 'err_cdev' defined but not used
drivers/staging/altpciechdma/altpciechdma.c: At top level:
drivers/staging/altpciechdma/altpciechdma.c:415: warning: 'ape_sg_to_chdma_table' defined but not used




-- 
~Randy
