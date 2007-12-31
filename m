Return-Path: <linux-kernel-owner+w=401wt.eu-S1759548AbXLaM24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548AbXLaM24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 07:28:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759079AbXLaM2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 07:28:48 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:53834 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758713AbXLaM2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 07:28:47 -0500
Message-ID: <4778E037.6000001@linux.vnet.ibm.com>
Date: Mon, 31 Dec 2007 17:57:35 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: FUJITA Tomonori <tomof@acm.org>
CC: fujita.tomonori@lab.ntt.co.jp, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: SCSI errors on powerpc with 2.6.24-rc6-mm1
References: <47733C01.1080002@linux.vnet.ibm.com> <20071228143043U.fujita.tomonori@lab.ntt.co.jp> <4774A74B.3000105@linux.vnet.ibm.com> <20071228165115O.tomof@acm.org>
In-Reply-To: <20071228165115O.tomof@acm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> 
> Oops, it's for -mm.
> 

Hi,

I just tested this patch and it works fine for me so far.

Tested-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
