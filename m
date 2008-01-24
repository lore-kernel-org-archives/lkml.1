Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835AbYAXPkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbYAXPkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 10:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbYAXPki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 10:40:38 -0500
Received: from de01egw02.freescale.net ([192.88.165.103]:50922 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbYAXPkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 10:40:37 -0500
Message-ID: <4798B14F.2020005@freescale.com>
Date: Thu, 24 Jan 2008 09:39:59 -0600
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Poonam_Aggrwal-b10812 <b10812@freescale.com>, kumar.gala@freescale.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, rubini@vision.unipv.it, linuxppc-dev@ozlabs.org,
       michael.barkowski@freescale.com, rich.cutler@freescale.com,
       ashish.kalra@freescale.com
Subject: Re: [PATCH] UCC TDM driver for QE based MPC83xx platforms.
References: <Pine.LNX.4.64.0801241014240.27491@linux121> <20080124171920.49d805cb.sfr@canb.auug.org.au>
In-Reply-To: <20080124171920.49d805cb.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:

>> +	tdm_ctrl[device_num]->ut_info->uf_info.tdm_tx_clk =
>> +			(char *) of_get_property(np, "fsl,tdm-tx-clk", NULL);
>                                 ^
> We don't normall put spaces here.

Since when?

-- 
Timur Tabi
Linux kernel developer at Freescale
