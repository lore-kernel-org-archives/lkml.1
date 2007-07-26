Return-Path: <linux-kernel-owner+w=401wt.eu-S1756222AbXGZAbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222AbXGZAbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 20:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbXGZAbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 20:31:42 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:42740 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751904AbXGZAbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 20:31:41 -0400
Message-ID: <46A7E891.1020006@vmware.com>
Date: Wed, 25 Jul 2007 17:19:29 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Gabriel Barazer <gabriel@oxeva.fr>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22 x86_64 : kernel initial decompression hangs on vmware
References: <46A7E606.4030001@oxeva.fr>
In-Reply-To: <46A7E606.4030001@oxeva.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel Barazer wrote:
> Hi,
>
> After upgrading kernel to 2.6.22 on a Vmware workstation guest version 
> 5.5 and 6 , the kernel decompression stage ("Decompressing Linux...") 
> is hanging for a very long time (~5 minutes) before finally  
> succeeding (displaying "done.\nBooting the kernel.\n"). During this 
> time, the VM process is eating all the CPU time during the 
> decompression, like an infinite loop. 

LKML is not the right place for this question.  You are running on Intel 
hardware?

Bring the discussion over to http://www.vmware.com/community forums

Zach
