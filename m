Return-Path: <linux-kernel-owner+w=401wt.eu-S1765907AbXKOQxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765907AbXKOQxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 11:53:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765198AbXKOQxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 11:53:34 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:53357 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764016AbXKOQxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 11:53:32 -0500
Message-ID: <473C7B16.3050700@linux.vnet.ibm.com>
Date: Thu, 15 Nov 2007 22:30:06 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Anton Blanchard <anton@samba.org>
CC: lkml <linux-kernel@vger.kernel.org>, linuxppc <linuxppc-dev@ozlabs.org>
Subject: Re: 2.6.24-rc1 on PPC64: machine check exception
References: <472F1F4C.3010507@linux.vnet.ibm.com> <20071105154055.GA4746@kryten> <472F5C5E.4030607@linux.vnet.ibm.com>
In-Reply-To: <472F5C5E.4030607@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
>> http://patchwork.ozlabs.org/linuxppc/patch?id=14475
> 
> Thanks for pointing me to this patch.  I will try out and let you know if
> this fixed the problem.

Hi Anton,

This patch fixed the problem.  I am able to run and profile ebizzy on 128-way
PPC64.  However this fix is not included in 2.6.24-rc2 as well.
I will watch for inclusion of this fix in 2.6.24.

--Vaidy
