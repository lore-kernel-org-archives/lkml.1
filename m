Return-Path: <linux-kernel-owner+w=401wt.eu-S1754244AbYKOQNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbYKOQNR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 11:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674AbYKOQNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 11:13:04 -0500
Received: from nebensachen.de ([195.34.83.29]:60006 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbYKOQND convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 11:13:03 -0500
X-Hashcash: 1:20:081115:loic.grenie@gmail.com::o9oO2pIFOHdMkvvD:00000000000000000000000000000000000000001e0Y
X-Hashcash: 1:20:081115:mingo@elte.hu::YnHyhGK2qJh+ld2T:00009bRd
X-Hashcash: 1:20:081115:gregkh@suse.de::QS/as5GLwIkSCcup:0004V8s
X-Hashcash: 1:20:081115:linux-kernel@vger.kernel.org::CELnUQZM5mJw9IC8:0000000000000000000000000000000005Ik4
X-Hashcash: 1:20:081115:stable@kernel.org::HL+/PpZb7uvfdPCv:000000000000000000000000000000000000000000001UUV
From: Elias Oltmanns <eo@nebensachen.de>
To: =?iso-8859-1?Q?Lo=EFc_Greni=E9?= <loic.grenie@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
Cc: "Greg KH" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: Linux 2.6.27.6
References: <20081113185350.GA3765@kroah.com>
	<9b06e8d20811150238ye81f6dck7e81e275ba11da9d@mail.gmail.com>
	<877i75p4ra.fsf@denkblock.local>
	<9b06e8d20811150701q6e38148k18df241343262713@mail.gmail.com>
Date: Sat, 15 Nov 2008 17:12:52 +0100
In-Reply-To: <9b06e8d20811150701q6e38148k18df241343262713@mail.gmail.com>
	(=?iso-8859-1?Q?=22Lo=EFc_Greni=E9=22's?= message of "Sat, 15 Nov 2008
 16:01:32 +0100")
Message-ID: <873ahtotmj.fsf@denkblock.local>
User-Agent: Gnus/5.110011 (No Gnus v0.11)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Loïc Grenié" <loic.grenie@gmail.com> wrote:
> 2008/11/15 Elias Oltmanns <eo@nebensachen.de>:
>> "Loïc Grenié" <loic.grenie@gmail.com> wrote:
>
>>>     No big deal, but commit 093327cb references
>>>   X86_CHECK_BIOS_CORRUPTION that is not available anywhere.
>>
>> You are talking about commit 71556e92, I suppose. Since the change log
>> entry has been written for the original commit 5649b7c3 in Linus' tree,
>> it refers to a feature that is available there
>> (X86_CHECK_BIOS_CORRUPTION) but has only been merged into mainline after
>> the release of 2.6.27.
>
>     No, I really mean 093327cb because it modifies arch/x86/Kconfig and in the
>   help for X86_RESERVE_LOW_64K it references
>   X86_CHECK_BIOS_CORRUPTION that, as you say, exists only in 2.6.28-rc?

Right, I see. Perhaps Ingo wants to do something about it?

Regards,

Elias
