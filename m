Return-Path: <linux-kernel-owner+w=401wt.eu-S1761930AbYDUOSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761930AbYDUOSn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 10:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757977AbYDUOSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 10:18:34 -0400
Received: from mga06.intel.com ([134.134.136.21]:7289 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756965AbYDUOSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 10:18:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,689,1199692800"; 
   d="scan'208";a="374868086"
Message-ID: <480CA230.3070007@linux.intel.com>
Date: Mon, 21 Apr 2008 07:18:24 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make x86/mm/dump_pagetables.c:pt_dump_init() static
References: <20080421085103.GA26897@cs181133002.pp.htv.fi>
In-Reply-To: <20080421085103.GA26897@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch makes the needlessly global pt_dump_init() static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Arjan van de Ven <arjan@linux.intel.com>

thanks
