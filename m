Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbZBKQtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbZBKQtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 11:49:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755973AbZBKQsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 11:48:54 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:32082 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554AbZBKQsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 11:48:53 -0500
Message-ID: <49930162.9060108@oracle.com>
Date: Wed, 11 Feb 2009 08:48:34 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2009-02-10-16-35 uploaded
References: <200902110036.n1B0aBZs013975@imap1.linux-foundation.org>
In-Reply-To: <200902110036.n1B0aBZs013975@imap1.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.49930149.0199:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2009-02-10-16-35 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://git.zen-sources.org/zen/mmotm.git


mmotm-2009-0210-1635/mm/shmem.c: In function 'shmem_zero_setup':
mmotm-2009-0210-1635/mm/shmem.c:2670: error: implicit declaration of function 'ima_shm_check'

needs the patch posted yesterday by Mimi Zohar:
  http://lkml.org/lkml/2009/2/10/553

-- 
~Randy
