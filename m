Return-Path: <linux-kernel-owner+w=401wt.eu-S1759956AbYHULxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759956AbYHULxB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 07:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758869AbYHULwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 07:52:53 -0400
Received: from msr35.hinet.net ([168.95.4.135]:56926 "EHLO msr35.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759213AbYHULww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 07:52:52 -0400
From: "Chen Pei Chao" <jackie73@ms2.hinet.net>
To: "'David Newall'" <davidn@davidnewall.com>
Cc: <linux-kernel@vger.kernel.org>, <jackie.chen@foxconn.com>
References: <01c301c9033c$5e881ef0$4901a8c0@tc.nsbg.efoxconn.com> <48ACE990.6000500@davidnewall.com>
Subject: =?windows-1255?Q?RE:_Is_there_linux_RAM_filesystem_with_a_fixed_amount_of?=
	=?windows-1255?Q?_memory=3F=FE?=
Date: Thu, 21 Aug 2008 19:51:05 +0800
Message-ID: <00a701c90384$43cbdcd0$4901a8c0@tc.nsbg.efoxconn.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="windows-1255"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <48ACE990.6000500@davidnewall.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Thread-Index: AckDQ1RfKGwK3i0wR+iN1l3vrPaKUQAP+6MA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> 
> Chen Pei Chao wrote:
> > I mounted a ramfs filesystem with 10M size, and have a check of
/proc/meminfo.
> > I find the ramfs also did not have the memory preallocation.
> >   
> Apparently I misunderstood what ramfs does.  Sorry for misdirecting you.

Never mind of this, and I use the kernel startup parameter "mem=10M" to
reserved the 
Memory that I don't want to use. Thanks.

Jackie
--

> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in the body of a message to 
> majordomo@vger.kernel.org More majordomo info at  
> http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

