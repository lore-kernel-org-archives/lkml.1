Return-Path: <linux-kernel-owner+w=401wt.eu-S1946006AbXBPRGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946006AbXBPRGN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 12:06:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946010AbXBPRGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 12:06:13 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:26560 "EHLO
	outbound4-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946006AbXBPRGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 12:06:12 -0500
X-BigFish: VP
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Fri, 16 Feb 2007 18:05:51 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Bill Davidsen" <davidsen@tmr.com>
cc: "Linux Kernel M/L" <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.20-get13] KVM-12 won't build
Message-ID: <20070216170551.GA2188@amd.com>
References: <45D5DC8D.7010609@tmr.com>
MIME-Version: 1.0
In-Reply-To: <45D5DC8D.7010609@tmr.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 16 Feb 2007 17:05:52.0491 (UTC)
 FILETIME=[B6D543B0:01C751EC]
X-WSS-ID: 69CB3BFD2MC8425517-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 11:32:13AM -0500, Bill Davidsen wrote:
> Goes out with an error message:
> 
>    cc -I /home/davidsen/downloads/kernel.org/linux-2.6.20-git13/include -MMD -MF ./.kvmctl.d 
> -g   -c -o kvmctl.o kvmctl.c
>    kvmctl.c:29:2: error: #error libkvm: userspace and kernel version mismatch
>    make[1]: *** [kvmctl.o] Error 1
>      
> I don't see a kvm-13 on the KVM website.

You will find the kvm-13 release in the SourceForge download area of
KVM[1]. Kvm-12 is still required for 2.6.20 kernels.

Joerg

[1] http://sourceforge.net/project/showfiles.php?group_id=180599

-- 
Joerg Roedel
Operating System Research Center
AMD Saxony LLC & Co. KG


