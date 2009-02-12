Return-Path: <linux-kernel-owner+w=401wt.eu-S1759543AbZBLQo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759543AbZBLQo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 11:44:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758049AbZBLQoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 11:44:00 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:40416 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757850AbZBLQn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 11:43:58 -0500
Message-ID: <499451E0.6060004@oracle.com>
Date: Thu, 12 Feb 2009 08:44:16 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: linux-next: Tree for February 12 (ide)
References: <20090212194408.ff7489c1.sfr@canb.auug.org.au>
In-Reply-To: <20090212194408.ff7489c1.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.499451C3.031F:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090211:


When
# CONFIG_BLK_DEV_IDEDMA is not set

linux-next-20090212/drivers/ide/ide-taskfile.c:108: error: 'ide_dma_intr' undeclared (first use in this function)


-- 
~Randy
