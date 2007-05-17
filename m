Return-Path: <linux-kernel-owner+w=401wt.eu-S1763537AbXEQHLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763537AbXEQHLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 03:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754745AbXEQHLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 03:11:38 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:41432 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754538AbXEQHLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 03:11:38 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Thu, 17 May 2007 12:41:12 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: David Miller <davem@davemloft.net>
cc: akpm@linux-foundation.org, marcel@holtmann.org, jikos@jikos.cz,
       gregkh@suse.de, jeremy@goop.org, maxk@qualcomm.com, clg@fr.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bluetooth: fix locking in hci_sock_dev_event()
In-Reply-To: <20070516.235111.07638844.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0705171238060.10635@cselinux1.cse.iitk.ac.in>
References: <Pine.LNX.4.64.0705171106550.9262@cselinux1.cse.iitk.ac.in>
 <20070516.235111.07638844.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007, David Miller wrote:
> From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> Date: Thu, 17 May 2007 11:13:36 +0530 (IST)
>
>> [PATCH] bluetooth: fix locking in hci_sock_dev_event()
>
> BTW, your email client corrupted the patch spaces and tabs
> a lot, I applied your patch by hand but I will not do that
> next time.  Please look into getting your email client to
> not corrupt the patches you send out, thank you.

Ick. That's the second time pine did that to me. Doesn't seem
to happen consistently/reproducibly, but I'll try to fix it
nonetheless, thanks.

Satyam
