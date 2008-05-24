Return-Path: <linux-kernel-owner+w=401wt.eu-S1759317AbYEXFYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317AbYEXFYb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 01:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbYEXFYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 01:24:23 -0400
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:57462 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbYEXFYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 01:24:22 -0400
Date: Sat, 24 May 2008 00:24:15 -0500
From: Matt Domsch <Matt_Domsch@dell.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] edd: consolidate error checks
Message-ID: <20080524052415.GF20890@auslistsprd01.us.dell.com>
References: <20080524020503.GB3470@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080524020503.GB3470@APFDCB5C>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2008 at 11:05:05AM +0900, Akinobu Mita wrote:
> Many show operations in edd_attribute have same error checks at the head.
> This patch consolidates these error checks to callee function.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Matt Domsch <Matt_Domsch@Dell.com>

Looks reasonable, but I haven't had a chance to test this.  Will do so
next week.

Thanks,
Matt

-- 
Matt Domsch
Linux Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux



