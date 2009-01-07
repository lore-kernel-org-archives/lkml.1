Return-Path: <linux-kernel-owner+w=401wt.eu-S1757503AbZAGS0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbZAGS0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 13:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118AbZAGS0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 13:26:03 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:62956 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088AbZAGS0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 13:26:01 -0500
Message-ID: <4964F38A.4040600@oracle.com>
Date: Wed, 07 Jan 2009 10:25:14 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2009-01-07-00-23 uploaded
References: <200901070828.n078SRKJ024599@imap1.linux-foundation.org>
In-Reply-To: <200901070828.n078SRKJ024599@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.4964F38E.01A7:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2009-01-07-00-23 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://git.zen-sources.org/zen/mmotm.git
> 
> It contains the following patches against 2.6.28:


After fixing the pdflush build error, now I get lots of this
build error:

kobject.c:(.text+0x6fb): undefined reference to `initmem_now_dynamic'


-- 
~Randy
