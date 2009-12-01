Return-Path: <linux-kernel-owner+w=401wt.eu-S1752885AbZLABeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbZLABeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 20:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbZLABeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 20:34:23 -0500
Received: from m50-111.126.com ([123.125.50.111]:45819 "HELO m50-111.126.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751792AbZLABeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 20:34:22 -0500
X-Greylist: delayed 1927 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Nov 2009 20:34:22 EST
Message-ID: <4B146B1A.8010607@126.com>
Date: Tue, 01 Dec 2009 09:02:18 +0800
From: helight <helight@126.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Brown, Len" <len.brown@intel.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Subject: [PATCH 2/2] fix a Section mismatch in arch/x86/pci/mmconfig-shared.c
 and include/linux/sfi_acpi.h
References: <4B13A094.2080504@126.com> <4B141A8E.1090104@zytor.com>
In-Reply-To: <4B141A8E.1090104@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: wKgtcbCr_OPPahRLgN6AAg--.60481S2
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUU5B7k042IEc7kJM7k042IE42xK82IY6r45
	ZwAYjxAI6xAIw28IcVAK0I8IjxAxM7k042IE4IxYO2xFxVAqjxCEw4Av424lb7Iv0xC_Jr
	1lb4IE77IF4wAFYI0v6s8v67xtM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v2
	0xvaj40_Wr0E3s1l1I0E4x80FVCIwcAKzIAtM7C26IkvcIIF6IxKo4kEV4yl1IIY67AEw4
	v_Jr0_Jr4l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E
	14v26rxl6s0DM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14
	v26rxl6s0DM2vj6xkI62vS6c8GOVWUtr1rJFyl52xGzVA2a4k0FcxF6xCjrcI26cIUMc02
	F40EFcxC0VAKzVAqx4xG6I80ewAv7VC2z280aVAFwI0_Jr0_Gr1lF7xvr2IY64vIr41lFV
	AaXTZC67ZELSn0mTvEwaV2v3VFvVW8Mx02cVAKzwCY1Ik26cxK6xAEc7vF6IAIbwCY02Av
	z4vE14v_KwCY0x0Ix7I2Y4AK6F4j6FyUMxAIw28IcxkI7VAKI48JMxCjnVAqn7xvrwC2zV
	AF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j
	6s0DYxBIdaVFxhVjvjDU0xZFpf9x0zR9ID7UUUUU=
X-CM-SenderInfo: 5khoxwlkw6ij2wof0z/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Hi Len,
>
> Do you want to take this one or should I?
>   
ooh! both ok！thing is that we fix the problem!
> 	-hpa
>
>
> On 11/30/2009 02:38 AM, helight wrote:
>   
>> acpi_sfi_table_parse() should be __init. tested on x86 system!
>>     
>
>   


-- 
---------------------------------
Zhenwen Xu - Open and Free
Home Page:	http://zhwen.org


