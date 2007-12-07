Return-Path: <linux-kernel-owner+w=401wt.eu-S1756469AbXLGV43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469AbXLGV43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 16:56:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755056AbXLGV4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 16:56:21 -0500
Received: from gate.crashing.org ([63.228.1.57]:45514 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754253AbXLGV4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 16:56:20 -0500
Cc: Olof Johansson <olof@lixom.net>, linuxppc-dev@ozlabs.org,
       LKML <linux-kernel@vger.kernel.org>
Message-Id: <975B5B2B-C1F3-4021-9AE2-8873FFE1BDEC@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: balbir@linux.vnet.ibm.com
In-Reply-To: <4759BCA2.1020809@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: [PATCH] Fake NUMA emulation for PowerPC
Date: Fri, 7 Dec 2007 15:55:20 -0600
References: <20071207211425.10223.91240.sendpatchset@balbir-laptop> <20071207212817.GA391@lixom.net> <4759BCA2.1020809@linux.vnet.ibm.com>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 7, 2007, at 3:35 PM, Balbir Singh wrote:

> Olof Johansson wrote:
>> Hi,
>>
>> On Sat, Dec 08, 2007 at 02:44:25AM +0530, Balbir Singh wrote:
>>
>>> Comments are as always welcome!
>>
>> Care to explain what this is useful for? (Not saying it's a stupid  
>> idea,
>> just wondering what the reason for doing it is).
>>
>
> In my case, I use it to test parts of my memory controller patches  
> on an
> emulated NUMA machine. I plan to use it to test out page migration
> across nodes.

Can you explain that further.  I'm still not clear on why this is  
useful.

- k
