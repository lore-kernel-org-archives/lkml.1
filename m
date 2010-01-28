Return-Path: <linux-kernel-owner+w=401wt.eu-S1756412Ab0A1S5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412Ab0A1S5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 13:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755822Ab0A1S5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 13:57:39 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:48427 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111Ab0A1S5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 13:57:38 -0500
Message-ID: <4B61DD8F.6020507@oracle.com>
Date: Thu, 28 Jan 2010 10:55:11 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>
Subject: Re: mmotm 2010-01-28-01-36 uploaded (sched.c + percpu)
References: <201001281002.o0SA2G0k002220@imap1.linux-foundation.org>
In-Reply-To: <201001281002.o0SA2G0k002220@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4B61DDDF.0075:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/10 01:36, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2010-01-28-01-36 has been uploaded to
>
>     http://userweb.kernel.org/~akpm/mmotm/
>
> and will soon be available at
>
>     git://zen-kernel.org/kernel/mmotm.git
>
> It contains the following patches against 2.6.33-rc5:


when CONFIG_SMP is not enabled:

kernel/sched.c:10915: error: 'percpu_counter_batch' undeclared (first use in this function)



-- 
~Randy
