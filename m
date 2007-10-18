Return-Path: <linux-kernel-owner+w=401wt.eu-S1765769AbXJRQG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765769AbXJRQG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 12:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754666AbXJRQGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 12:06:20 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:51501 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbXJRQGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 12:06:19 -0400
Date: Thu, 18 Oct 2007 09:07:30 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: -
 x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron.patch removed from
 -mm tree
In-reply-to: <200710180709.l9I794J2031878@imap1.linux-foundation.org>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai.Lu@Sun.COM
Message-id: <471784C2.3080807@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <200710180709.l9I794J2031878@imap1.linux-foundation.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


akpm@linux-foundation.org wrote:
> The patch titled
>      x86_64: check MSR to get MMCONFIG for AMD Family 10h Opteron
> has been removed from the -mm tree.  Its filename was
>      x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron.patch
> 
> This patch was dropped because it was merged into mainline or a subsystem tree
> 
> ------------------------------------------------------
> Subject: x86_64: check MSR to get MMCONFIG for AMD Family 10h Opteron
> From: Yinghai Lu <Yinghai.Lu@Sun.COM>
> 
> So even MCFG is not there, we still can use MMCONFIG.
> 
> Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  arch/i386/pci/mmconfig-shared.c |   58 ++++++++++++++++++++++++++----
>  1 file changed, 52 insertions(+), 6 deletions(-)

Andrew,

where was this one going? Thomas got it?

YH
