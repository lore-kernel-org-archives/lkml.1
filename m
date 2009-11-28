Return-Path: <linux-kernel-owner+w=401wt.eu-S1754229AbZK1EBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbZK1EBr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 23:01:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754195AbZK1EBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 23:01:46 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:26352 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188AbZK1EBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 23:01:46 -0500
Message-ID: <4B10A04A.7090703@oracle.com>
Date: Fri, 27 Nov 2009 20:00:10 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Joern Engel <joern@logfs.org>
Subject: Re: linux-next: Tree for November 27 (logfs: hash_index)
References: <20091127181915.a6af7ba3.sfr@canb.auug.org.au>
In-Reply-To: <20091127181915.a6af7ba3.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4B10A0A1.0011:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20091126:


on i386 (X86_32):

fs/built-in.o: In function `hash_index':
dir.c:(.text+0x6c1f2): undefined reference to `__umoddi3'

-- 
~Randy

