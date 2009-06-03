Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbZFCEJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbZFCEJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 00:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750857AbZFCEJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 00:09:36 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:60896 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbZFCEJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 00:09:36 -0400
Message-ID: <4A25F814.7030101@oracle.com>
Date: Tue, 02 Jun 2009 21:12:04 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>
Subject: Re: mmotm 2009-06-02-16-11 uploaded (staging)
References: <200906022331.n52NVJhG015117@imap1.linux-foundation.org>
In-Reply-To: <200906022331.n52NVJhG015117@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt002.oracle.com [141.146.116.11]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4A25F758.0144:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2009-06-02-16-11 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://git.zen-sources.org/zen/mmotm.git


drivers/staging/agnx/pci.c:64:3: warning: "/*" within comment
drivers/staging/agnx/pci.c:223:2: warning: "/*" within comment

drivers/staging/android/lowmemorykiller.c:106: error: 'struct task_struct' has no member named 'oomkilladj'

-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
