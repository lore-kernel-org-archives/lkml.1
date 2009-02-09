Return-Path: <linux-kernel-owner+w=401wt.eu-S1755921AbZBIRQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbZBIRQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 12:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754734AbZBIRP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 12:15:59 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:45658 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763AbZBIRP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:15:58 -0500
Message-ID: <499064CC.1030907@oracle.com>
Date: Mon, 09 Feb 2009 09:15:56 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, bzolnier@gmail.com
Subject: Re: linux-next: Tree for February 9 (ide-dma)
References: <20090209193908.1a448944.sfr@canb.auug.org.au>
In-Reply-To: <20090209193908.1a448944.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.499064B8.01BE:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> [I accidentally deleted the merge and quilt-import logs today :-( - I
> wonder if any would have noticed :-).  The merge summary still appears
> below.]
> 
> Changes since 20090206:
> 
> New tree:
> 	aoe
> 
> Undropped trees:
> 	ide


When CONFIG_BLK_DEV_IDEDMA=n:

drivers/ide/ide-taskfile.c:104: error: implicit declaration of function 'ide_build_sglist'

-- 
~Randy
