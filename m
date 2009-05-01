Return-Path: <linux-kernel-owner+w=401wt.eu-S1757882AbZEAPRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882AbZEAPRc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 11:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756114AbZEAPRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 11:17:23 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:62894 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028AbZEAPRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 11:17:22 -0400
Message-ID: <49FB12D0.5030809@oracle.com>
Date: Fri, 01 May 2009 08:18:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for May 1 (tmpfs)
References: <20090501163405.973f9088.sfr@canb.auug.org.au>
In-Reply-To: <20090501163405.973f9088.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010205.49FB127A.0217:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090430:


When CONFIG_SHMEM=n:

init/built-in.o: In function `kernel_init':
main.c:(.init.text+0x8be): undefined reference to `init_tmpfs'



-- 
~Randy
