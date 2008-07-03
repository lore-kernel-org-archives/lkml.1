Return-Path: <linux-kernel-owner+w=401wt.eu-S1755787AbYGCMA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbYGCMA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755320AbYGCL7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 07:59:21 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:34584 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273AbYGCL7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 07:59:19 -0400
Message-ID: <486C975B.2030702@linux.vnet.ibm.com>
Date: Thu, 03 Jul 2008 14:39:47 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Paul Menage <menage@google.com>,
       Linux Containers <containers@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelianov <xemul@openvz.org>,
       Andrea Righi <righi.andrea@gmail.com>
Subject: Re: [PATCH -mmotm] res_counter: fix building failure
References: <486B1D3D.5070805@cn.fujitsu.com> <6599ad830807012345r4f02f9acq3c8e9be633e109e8@mail.gmail.com> <486B250D.3090605@cn.fujitsu.com>
In-Reply-To: <486B250D.3090605@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> Paul Menage wrote:
>> On Tue, Jul 1, 2008 at 11:16 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>>> kernel/res_counter.c: In function 'res_counter_memparse_write_strategy':
>>> kernel/res_counter.c:115: error: implicit declaration of function 'PAGE_ALIGN'
>>>
>>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>> Acked-by: Paul Menage <menage@google.com>
>>
>> Thanks - what architecture did it break on?

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

CC'ing Andre as well


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
