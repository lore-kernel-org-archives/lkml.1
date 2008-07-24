Return-Path: <linux-kernel-owner+w=401wt.eu-S1753043AbYGXIts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbYGXIts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 04:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbYGXItl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 04:49:41 -0400
Received: from mga12.intel.com ([143.182.124.36]:7770 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751349AbYGXItk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 04:49:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,245,1215414000"; 
   d="scan'208";a="24207354"
Message-ID: <4888421D.4090805@linux.intel.com>
Date: Thu, 24 Jul 2008 01:49:33 -0700
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Adrian Bunk <bunk@kernel.org>, ambx1@neo.rr.com,
       Rene Herman <rene.herman@gmail.com>, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>
Subject: Re: [2.6 patch] make pnp_build_option() static
References: <20080722172021.GN14846@cs181140183.pp.htv.fi> <200807231300.42905.bjorn.helgaas@hp.com>
In-Reply-To: <200807231300.42905.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> On Tuesday 22 July 2008 11:20:21 am Adrian Bunk wrote:
>> pnp_build_optionq() can now become static.
>>
>> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> 
> PNP patches have been going through the ACPI tree lately.
> I copied Andi and Len.

Looks good thanks. I'm currently a bit behind with patches because
I'm at OLS and still focussing on patches for .27 only, but I'll
process all the post .27 patches soon.

-Andi
