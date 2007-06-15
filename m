Return-Path: <linux-kernel-owner+w=401wt.eu-S1752540AbXFOLuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbXFOLuP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 07:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbXFOLtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 07:49:42 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:40235 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753642AbXFOLtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 07:49:39 -0400
Message-ID: <46727CCF.9030905@grupopie.com>
Date: Fri, 15 Jun 2007 12:49:35 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Bernd Paysan <bernd.paysan@gmx.de>
CC: Al Viro <viro@ftp.linux.org.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr> <20070614170902.GQ21478@ftp.linux.org.uk> <467178D3.6010204@grupopie.com> <200706151014.45383.bernd.paysan@gmx.de>
In-Reply-To: <200706151014.45383.bernd.paysan@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Paysan wrote:
> On Thursday 14 June 2007 19:20, Paulo Marques wrote:
>> Watching the output of the first grep without "wc -l" shows that,
>> although it is not 100% accurate, it is still ok just to get a rough
>> estimate.
>>
>> So yes, ~6300 files are definitely more than a couple ;)

I knew I shouldn't post into the yearly GPL flame-fest... :(

> Most of them don't say anything, so they are "any GPL" by the author. 

I've contributed some code for the kernel (unlike yourself, AFAICT), and 
believe me, I did so under GPL v2. The COPYING file is pretty much self 
explanatory, so I didn't need to add any explicit license statement to 
my code.

> When 
> do you people accept that Linus can't change the GPL, he can only add 
> comments of what he thinks is the case! His interpretation of the GPLv2 
> might be that not saying anything about the version means "v2 only", but if 
> he does so, he's simply wrong. He was wrong in the module case, as well, 
> and dropped this comment a while ago. He might drop this comment in future, 
> as well. In fact, anybody can drop this comment, as it's just a comment.

Linus can't and is not _changing_ the GPL. He can however use whatever 
license he sees fit for _his_ code just like all the other kernel 
developers do.

People seem to forget that the kernel license in COPYING *never had* the 
"v2 or later" clause. Never. Period.

The only change in license was from the previous hand-made one from 
Linus into GPL v2 only. And that is perfectly fine since the previous 
license was even more permissive than GPL v2.

> The kernel *as a whole* is clearly under GPLv2 only from Linus' comment, 
> which is in fact true, since the common subset of GPL versions from all 
> authors is indeed GPLv2 (by virtue of some files from Al Viro, and maybe 
> some other explicit GPL v2 files). The author must specify the version 
> himself, there simply is no other way. If you don't specify any, it's "any 
> version", because I can license all patches straight from the authors. 

No, it is not "any version". It is the license specified in COPYING and 
nothing else.

> The way the GPLv2 allows you to explicitely specify "any version" is by not 
> saying anything about the version at all. Linus isn't in the positition to 
> change that unless he does a substantial change to the file, and also adds 
> a comment that this file is now GPLv2 only.

Man, I sure ain't a lawyer, but people in these discussions seem to not 
understand the basics at all.

And the basics are: "people who write the code decide the license to 
give it". And that's just it.

And people who write kernel code are perfectly aware that the kernel 
license is GPL v2 only, and always has been (except for the initial 
linus license).

So don't go around saying that because people don't put explicit license 
statements they don't care about the license. I care very much about the 
license, and would have never contributed to the kernel if it had a BSD 
license of some sort.

Putting a license statement in _every_ file in the kernel tree would 
just be idiotic when there is such a clear COPYING file in the root of 
the kernel tree.

-- 
Paulo Marques - www.grupopie.com

"Oh dear, I think you'll find reality's on the blink again."
Marvin The Paranoid Android
