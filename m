Return-Path: <linux-kernel-owner+w=401wt.eu-S1757715AbZBTCPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715AbZBTCPZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 21:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115AbZBTCPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 21:15:13 -0500
Received: from rrcs-71-43-195-114.se.biz.rr.com ([71.43.195.114]:46651 "EHLO
	mail.ultrawaves.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752667AbZBTCPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 21:15:12 -0500
X-Greylist: delayed 1321 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Feb 2009 21:15:11 EST
Message-ID: <499E0D03.3050604@lammerts.org>
Date: Thu, 19 Feb 2009 20:53:07 -0500
From: Eric Lammerts <eric@lammerts.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de
Subject: Re: [PATCH][retry 1] Conform L3 Cache Index Disable to Linux standards
References: <200902191546.22214.mark.langsdorf@amd.com>
In-Reply-To: <200902191546.22214.mark.langsdorf@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/09 16:46, Mark Langsdorf wrote:
> +++ b/Documentation/ABI/testing/sysfs-devices-cache_disable	Thu Feb 19 13:36:25 2009 -0600

> +		 Currently, only AMD Family 10h Processors support cache index
> +		 disable, and only for their L3 caches.  See the BIOS and
> +		 Kernel Developer's Guide at
> +		 http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_do...
> +		 for formatting information and other details on the

that url doesn't work very well...

Eric
