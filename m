Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318Ab0AOVWW (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 16:22:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758226Ab0AOVWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 16:22:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:49587 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755692Ab0AOVWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 16:22:21 -0500
Message-ID: <4B50DC35.4080502@kernel.org>
Date: Fri, 15 Jan 2010 13:20:53 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 2/7] x86/pci: use resource_size_t in update_res -v2
References: <4B2BE063.4040704@kernel.org>	<4B2BE181.5090406@kernel.org> <20100115114956.6207cfa4@jbarnes-piketon>
In-Reply-To: <20100115114956.6207cfa4@jbarnes-piketon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2010 11:49 AM, Jesse Barnes wrote:
> On Fri, 18 Dec 2009 12:09:37 -0800
> Yinghai Lu <yinghai@kernel.org> wrote:
> 
>>
>>
>> prepare to enable 32bit intel and amd bus
>>
>> v2: change __init to __devinit
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> ---
> 
> Applied 2-3 to my linux-next branch, thanks.  (1 was already applied to
> fix Jens' problem over the holidays, thanks hpa).
> 

will find out good apply sequence....

YH
