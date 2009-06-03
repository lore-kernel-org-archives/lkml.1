Return-Path: <linux-kernel-owner+w=401wt.eu-S1758792AbZFCPV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792AbZFCPV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 11:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756275AbZFCPVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 11:21:51 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:18694 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504AbZFCPVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 11:21:50 -0400
Message-ID: <4A2695C1.2060104@oracle.com>
Date: Wed, 03 Jun 2009 08:24:49 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
Subject: Re: linux-next: Tree for June 3 (staging)
References: <20090603190952.2dd0cc70.sfr@canb.auug.org.au>
In-Reply-To: <20090603190952.2dd0cc70.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt005.oracle.com [141.146.116.14]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4A269503.0089:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Looks like a real rush since -rc7 ...


drivers/staging/comedi/drivers/adq12b.c:328: error: implicit declaration of function 'udelay'


drivers/staging/mrst_nand/ffsport.c:360:error: 'struct request' has no member named 'sector'
drivers/staging/mrst_nand/ffsport.c:376:error: 'struct request' has no member named 'sector'
drivers/staging/mrst_nand/ffsport.c:376:error: 'struct request' has no member named 'current_nr_sectors'
drivers/staging/mrst_nand/ffsport.c:380:error: 'struct request' has no member named 'sector'
drivers/staging/mrst_nand/ffsport.c:381:error: 'struct request' has no member named 'current_nr_sectors'
drivers/staging/mrst_nand/ffsport.c:392:error: 'struct request' has no member named 'current_nr_sectors'
drivers/staging/mrst_nand/ffsport.c:499:error: implicit declaration of function 'elv_next_request'
drivers/staging/mrst_nand/ffsport.c:517:error: implicit declaration of function 'end_request'
drivers/staging/mrst_nand/ffsport.c:738:error: implicit declaration of function 'blk_queue_hardsect_size'


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
