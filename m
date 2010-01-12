Return-Path: <linux-kernel-owner+w=401wt.eu-S1752865Ab0ALHkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab0ALHkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 02:40:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750834Ab0ALHkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 02:40:03 -0500
Received: from m50-112.126.com ([123.125.50.112]:33752 "EHLO m50-112.126.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741Ab0ALHkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 02:40:01 -0500
X-Greylist: delayed 1860 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Jan 2010 02:40:01 EST
Message-ID: <4B4C1FED.7010603@126.com>
Date: Tue, 12 Jan 2010 15:08:29 +0800
From: "Figo.zhang" <figo1802@126.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091215 Shredder/3.0
MIME-Version: 1.0
To: gregkh@suse.de, hjanssen@microsoft.com, haiyangz@microsoft.com,
       torvalds@linux-foundation.org, akpm@osdl.org, mingo@elte.hu
CC: linux-kernel@vger.kernel.org
Subject: Re: [staging/hv] why it not follow kernel codingstyle?
References: <4B4C16CA.4010401@126.com>
In-Reply-To: <4B4C16CA.4010401@126.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: j9KowLDr2GD0H0xLwOohAQ--.36000S2
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUU5t7k042IE42xK82IY6r45ZwAYjxAI6xAI
	w28IcVAK0I8IjxAxM7k042IE4IxYO2xFxVAqjxCEw4Av424lb7Iv0xC_Jr1lb4IE77IF4w
	AFYI0v6xAqj4kS57xkM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20EY4v20xvaj40_
	Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwV
	C0I7IYx2IY6xkF7I0E14v26rxl6s0DM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK
	6I8E87Iv6xkF7I0E14v26rxl6s0DM2kK67kvxFCE548m6r1fGryUXwAa7VCY0VAaVVAqrc
	v_Jw1UWr13M2vYz4IE04k24VAvwVAKI4IrMc804VCY07AIYIkI8VC2zVCFFI0UMc02F40E
	FcxC0VAKzVAqx4xG6I80ewAv7VC2z280aVAFwI0_Jr0_Gr1lF7xvr2IY64vIr41lFVAaXT
	ZC67ZELSn0mTvEwaV2v3VFvVW8Mx02cVCv0xWlc2xSY4AK67AK6r4xMxkI7II2jI8vz4v_
	Cr0_Zr1l42xK82IYc2Ij64vIr41l4x8a6c8ajcxJMI8E67AF67kF1VAFwI0_JF0_Jw1lIx
	AIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvE
	x4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7sRMEfO3UUUUU==
X-CM-SenderInfo: 5ilj0iqyqsqiyswou0bp/1tbi3hRWmEkZjAldwgAAsO
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi all,

i read the driver/staging/hv code, why it will apply into kernel tree 
that it not follow the kernel codingstyle? it all of "Hungarian
notation".

see Documentation/CodingStyle. In this document,(line 254) it says: 
"Encoding the type of a function into the name (so-called Hungarian
notation) is brain damaged".

so it ruin the kernel tree, it had better let the author rewrite it 
follow the "linux kernel CodingStyle".

Best,
Figo.zhang


