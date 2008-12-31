Return-Path: <linux-kernel-owner+w=401wt.eu-S1755564AbYLaDwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbYLaDwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 22:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbYLaDwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 22:52:09 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:50098 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbYLaDwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 22:52:08 -0500
Message-ID: <495AEC55.40007@oracle.com>
Date: Tue, 30 Dec 2008 19:51:49 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: mmotm 2008-12-30-16-05 uploaded (mtd)
References: <200812310006.mBV060iV029753@imap1.linux-foundation.org>
In-Reply-To: <200812310006.mBV060iV029753@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.495AEC58.0099:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2008-12-30-16-05 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://git.zen-sources.org/zen/mmotm.git
> 
> It contains the following patches against 2.6.28:


mmotm-2008-1230-1605/drivers/mtd/nand/nandsim.c:1326: error: dereferencing pointer to incomplete type
mmotm-2008-1230-1605/drivers/mtd/nand/nandsim.c:1326: error: 'PF_MEMALLOC' undeclared (first use in this function)
mmotm-2008-1230-1605/drivers/mtd/nand/nandsim.c:1328: error: dereferencing pointer to incomplete type
mmotm-2008-1230-1605/drivers/mtd/nand/nandsim.c:1335: error: dereferencing pointer to incomplete type
mmotm-2008-1230-1605/drivers/mtd/nand/nandsim.c:1335: error: 'PF_MEMALLOC' undeclared (first use in this function)


I sent a patch for this around Dec. 15.  I wonder where it is now.

~Randy


-- 
~Randy
