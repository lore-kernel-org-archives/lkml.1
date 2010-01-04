Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543Ab0ADPRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab0ADPRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 10:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508Ab0ADPRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 10:17:17 -0500
Received: from smtpauth.net4india.com ([202.71.129.41]:46696 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab0ADPRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 10:17:16 -0500
Message-ID: <4B420665.4090107@xenontk.org>
Date: Mon, 04 Jan 2010 20:46:53 +0530
From: David John <davidjon@xenontk.org>
Reply-To: davidjon@xenontk.org
User-Agent: Mozilla/5.0 (X11; X; Linux x86_64; rv:1.9.1.5) Gecko/20091209 Thunderbird/3.0
MIME-Version: 1.0
To: Yuhong Bao <yuhongbao_386@hotmail.com>
CC: arjan@infradead.org, ch@zeha.at, linux-kernel@vger.kernel.org,
       bruce.w.allan@intel.com, jpiszcz@lucidpixels.com
Subject: Re: Linux* is not supported on the Intel(R) Desktop Board DP55KG
 - Kernel still hangs upon reboot.
References: <20100103202345.GA20015@percival.namespace.at> <alpine.DEB.2.00.1001031637230.17894@p34.internal.lan>,<20100103150300.170dedee@infradead.org> <SNT125-W149307D1A737021C150C9CC3740@phx.gbl>
In-Reply-To: <SNT125-W149307D1A737021C150C9CC3740@phx.gbl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2010 11:17 AM, Yuhong Bao wrote:
> 
>> btw this can be automated... just needs a DMI quirk.
>> someone needs to get dmidecode output and add it to the existing
>> table of reboot= quirks...
>>
>>
>>
>> --
>> Arjan van de Ven Intel Open Source Technology Centre
> 
> Note BTW that this is one of Intel's own motherboards!
> In fact, I also have read about Intel's own DG45FC board having EHCI handoff trouble with Linux.
> 

Yes, but the BIOS is probably not done by Intel.
