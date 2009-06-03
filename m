Return-Path: <linux-kernel-owner+w=401wt.eu-S1758098AbZFCPrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098AbZFCPrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 11:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756063AbZFCPrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 11:47:08 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:19873 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbZFCPrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 11:47:07 -0400
Message-ID: <4A269BB2.4050508@oracle.com>
Date: Wed, 03 Jun 2009 08:50:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
Subject: Re: linux-next: Tree for June 3 (driver core)
References: <20090603190952.2dd0cc70.sfr@canb.auug.org.au>
In-Reply-To: <20090603190952.2dd0cc70.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt009.oracle.com [141.146.116.18]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4A269AF4.0133:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Looks like a real rush since -rc7 ...


drivers/built-in.o: In function `register_mem_sect_under_node':
(.text+0x1d305b): undefined reference to `sysfs_create_link_nowarn'


I can't find this function's implementation when CONFIG_SYSFS=y.


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
