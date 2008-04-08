Return-Path: <linux-kernel-owner+w=401wt.eu-S1753326AbYDHHJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbYDHHJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 03:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbYDHHJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 03:09:30 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:34822 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbYDHHJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 03:09:30 -0400
Message-ID: <47FB193A.8070801@linux.vnet.ibm.com>
Date: Tue, 08 Apr 2008 12:35:30 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Pavel Emelianov <xemul@openvz.org>, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, linux-kernel@vger.kernel.org,
       taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm] Add an owner to the mm_struct (v8)
References: <20080404080544.26313.38199.sendpatchset@localhost.localdomain> <47F79102.6090406@linux.vnet.ibm.com> <6599ad830804051023v69caa3d4h6e26ccb420bca899@mail.gmail.com> <47F7BB69.3000502@linux.vnet.ibm.com> <6599ad830804051057n2f2802e4w6179f2e108467494@mail.gmail.com> <47F7CC08.4090209@linux.vnet.ibm.com> <6599ad830804051629k3649dbc4na92bb3d0cd7a0492@mail.gmail.com> <47F861C8.7080700@linux.vnet.ibm.com> <6599ad830804072337g2e7b4613hdcc05062dc2ca4e0@mail.gmail.com> <47FB162D.1020506@linux.vnet.ibm.com> <6599ad830804072357o2fd5e9bco3309d151e270e62e@mail.gmail.com>
In-Reply-To: <6599ad830804072357o2fd5e9bco3309d151e270e62e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Mon, Apr 7, 2008 at 11:52 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>  I agree, but like I said earlier, this was the easily available ready made
>>  application I found. Do you know of any other highly threaded micro benchmark?
>>
> 
> How about a simple program that creates N threads that just sleep,
> then has the main thread exit?
> 

That is not really representative of anything. I have that program handy. How do
we measure the impact on throughput?

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
