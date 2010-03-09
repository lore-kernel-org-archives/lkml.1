Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441Ab0CIM0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 07:26:32 -0500
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:40973 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab0CIM03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 07:26:29 -0500
Message-ID: <4B963E38.3010207@csr.com>
Date: Tue, 09 Mar 2010 12:25:28 +0000
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] UWB fixes for 2.6.34
References: <4B8BE657.2050906@csr.com>
In-Reply-To: <4B8BE657.2050906@csr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 09 Mar 2010 12:25:28.0583 (UTC) FILETIME=[9A6B6170:01CABF83]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Vrabel wrote:
> Linus,
> 
> Just a handful for trivial patches for the UWB subsystem.

Looks like you missed this pull request for 2.6.34.  Can this be pulled
for 2.6.34-rc2?

Thanks.

David

> The following changes since commit baac35c4155a8aa826c70acee6553368ca5243a2:
>   Xiaotian Feng (1):
>         security: fix error return path in ima_inode_alloc
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/dvrabel/uwb.git for-upstream
> 
> Ben Hutchings (1):
>       uwb: declare MODULE_FIRMWARE() in i1480 DFU driver
> 
> Dan Carpenter (1):
>       uwb: remove duplicate cpu_to_le16()
> 
> David Vrabel (2):
>       uwb: wlp: refactor wlp_get_<attribute>() macros
>       Merge branch 'master' of
> git://git.kernel.org/.../torvalds/linux-2.6 into for-upstream
> 
> Márton Németh (1):
>       uwb: make USB device id table constant
> 
>  drivers/uwb/hwa-rc.c        |    2 +-
>  drivers/uwb/i1480/dfu/usb.c |   12 +++--
>  drivers/uwb/wlp/messages.c  |  106
> +++++++++++++++++++++++++------------------
>  3 files changed, 69 insertions(+), 51 deletions(-)
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/


Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
