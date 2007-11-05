Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbXKESJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbXKESJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 13:09:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbXKESJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 13:09:48 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:51136 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbXKESJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 13:09:47 -0500
Message-ID: <472F5C5E.4030607@linux.vnet.ibm.com>
Date: Mon, 05 Nov 2007 23:39:34 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Anton Blanchard <anton@samba.org>
CC: lkml <linux-kernel@vger.kernel.org>, linuxppc <linuxppc-dev@ozlabs.org>
Subject: Re: 2.6.24-rc1 on PPC64: machine check exception
References: <472F1F4C.3010507@linux.vnet.ibm.com> <20071105154055.GA4746@kryten>
In-Reply-To: <20071105154055.GA4746@kryten>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Blanchard wrote:
> Hi
> 
>> I got the following exception on a 128-way PPC64 machine while running
>> ebizzy-0.2 benchmark.
> 
> Is it a 64bit application? Im guessing its fixed by this:

Hi Anton,

The ebizzy application I tried is 64-bit.

> http://patchwork.ozlabs.org/linuxppc/patch?id=14475

Thanks for pointing me to this patch.  I will try out and let you know if
this fixed the problem.

--Vaidy

