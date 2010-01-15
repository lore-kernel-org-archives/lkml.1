Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758325Ab0AOVTs (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 16:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758317Ab0AOVTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 16:19:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:57627 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702Ab0AOVTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 16:19:42 -0500
Message-ID: <4B50DBA6.8070406@kernel.org>
Date: Fri, 15 Jan 2010 13:18:30 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 4/7] x86/pci: use u64 instead of size_t in amd_bus.c -v2
References: <4B2BE063.4040704@kernel.org>	<4B2BE189.9060708@kernel.org> <20100115114928.5e565e30@jbarnes-piketon>
In-Reply-To: <20100115114928.5e565e30@jbarnes-piketon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2010 11:49 AM, Jesse Barnes wrote:
> On Fri, 18 Dec 2009 12:09:45 -0800
> Yinghai Lu <yinghai@kernel.org> wrote:
> 
>>
>> prepare to enable it for 32bit
>>
>> -v2: remove not needed cast
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
> 
> 4-6 have conflicts against my linux-next branch, can you refresh them?

because it will rely on range.c related cleanup. can we make it go through tip
and add acked-by from you?

Thanks

Yinghai
