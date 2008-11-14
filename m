Return-Path: <linux-kernel-owner+w=401wt.eu-S1755157AbYKNRxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbYKNRxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 12:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbYKNRxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 12:53:04 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:56560 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbYKNRxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 12:53:03 -0500
Date: Fri, 14 Nov 2008 09:52:47 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh <greg@kroah.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 14 (staging)
Message-Id: <20081114095247.6b195091.randy.dunlap@oracle.com>
In-Reply-To: <20081114184021.ed198f4b.sfr@canb.auug.org.au>
References: <20081114184021.ed198f4b.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010201.491DBAF4.0060:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2008 18:40:21 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20081113:
> 
> New tree:
> 	staging


drivers/staging/benet/mpu.c:146: error: implicit declaration of function 'udelay'

drivers/staging/comedi/proc.c:89: error: redefinition of 'comedi_proc_init'
drivers/staging/comedi/comedidev.h:359: error: previous definition of 'comedi_proc_init' was here
drivers/staging/comedi/proc.c:98: error: redefinition of 'comedi_proc_cleanup'
drivers/staging/comedi/comedidev.h:362: error: previous definition of 'comedi_proc_cleanup' was here


---
~Randy
