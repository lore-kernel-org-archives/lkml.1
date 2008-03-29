Return-Path: <linux-kernel-owner+w=401wt.eu-S1758771AbYC2BGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771AbYC2BGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 21:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755987AbYC2BGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 21:06:46 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:34662 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976AbYC2BGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 21:06:46 -0400
Message-ID: <47ED953A.1050906@linux.vnet.ibm.com>
Date: Sat, 29 Mar 2008 06:32:50 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Pavel Emelianov <xemul@openvz.org>, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm] Add an owner to the mm_struct (v2)
References: <20080328082316.6961.29044.sendpatchset@localhost.localdomain> <6599ad830803280401r68d30e91waaea8eb1de36eb52@mail.gmail.com> <47ECE662.3060506@linux.vnet.ibm.com> <6599ad830803280705o4213c448r991cbf9da6ffe2f1@mail.gmail.com> <47ED0621.4050304@linux.vnet.ibm.com> <6599ad830803280838s19ffc366w1a950ebb12e2907b@mail.gmail.com> <47ED34A4.70604@linux.vnet.ibm.com> <6599ad830803281152g33e693f5s4c7090a503d2751d@mail.gmail.com>
In-Reply-To: <6599ad830803281152g33e693f5s4c7090a503d2751d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> Hi Balbir,
> 
> Could you send out the latest version of your patch? I suspect it's
> changed a bit based on on this review and it would be good to make
> sure we're both on the same page.

Sure, let me rework that and send it across.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
