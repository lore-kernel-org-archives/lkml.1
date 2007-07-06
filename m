Return-Path: <linux-kernel-owner+w=401wt.eu-S1764270AbXGFVck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764270AbXGFVck (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 17:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762102AbXGFVcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 17:32:32 -0400
Received: from vms048pub.verizon.net ([206.46.252.48]:49620 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbXGFVcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 17:32:32 -0400
Date: Fri, 06 Jul 2007 16:32:13 -0500
From: Corey Minyard <minyard@acm.org>
Subject: Re: [PATCH] Serial 8250: Handle saving the clear-on-read bits from the
 LSR and MSR
In-reply-to: <20070706210918.255a6a68@the-village.bc.nu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>, linux-serial@vger.kernel.org
Message-id: <468EB4DD.7070800@acm.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <20070706194244.GA18371@localdomain>
 <20070706210918.255a6a68@the-village.bc.nu>
User-Agent: Icedove 1.5.0.10 (X11/20070328)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Fri, 06 Jul 2007 14:42:44 -0500
> Corey Minyard <minyard@acm.org> wrote:
>
>   
>> I haven't heard anything on this patch.  This is moved up to 2.6.22-rc7.
>> Is there anything that needs to change to get it included?
>>     
>
> Testing for some time in -mm in case of side effects and then pushing it
> to an early -rc of a new kernel
>   
I just pulled 2.6.22-rc6-mm1 and I looked in all the previous 2.6.22 mm 
patches and I don't see it.  Am I missing something?

-corey
