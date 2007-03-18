Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795AbXCREwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbXCREwO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 00:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbXCREwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 00:52:13 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:27518 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbXCREwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 00:52:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=bqi7fwPTUPhoc5tRtSY4F7Cmu+IUg37lgCYr/JR2uJja89xv3I0zo5HyPv8A7FNwKM+QpPTsgAWfr+tEx5I+QbSrLV72kh2YGdIIz5WQG+2VcSWRTTldjF8ceoTfFUUomphf+bJUkCjQGy17IyKZ68TuBRPq7Dl1csW/AH8i3Qs=
Message-ID: <45FCC575.4080902@gmail.com>
Date: Sun, 18 Mar 2007 13:52:05 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: rol@as2917.net
CC: "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Jeff Garzik'" <jeff@garzik.org>, "'Alan Cox'" <alan@redhat.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       linux-ide@vger.kernel.org, "'LKML'" <linux-kernel@vger.kernel.org>,
       "'Eric D. Mudama'" <edmudama@gmail.com>
Subject: Re: [git patches] libata fixes
References: <00b901c768cf$fc359f00$2101a8c0@donald>
In-Reply-To: <00b901c768cf$fc359f00$2101a8c0@donald>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Rolland wrote:
> Hello,
> 
>> The kernel says that NCQ is turned off due to excessive 
>> errors.  If your
>> HSM violation is intermittent, it might not trigger tho.
> 
> I've just grep'ed thru all my messages, and I can't find anything 
> stating that NCQ is being turned off...

Can you put the harddisk under high load and see what happens?  How
often do those errors occur?  Care to post full dmesg?

-- 
tejun
