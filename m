Return-Path: <linux-kernel-owner+w=401wt.eu-S1760531AbXFVSkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760531AbXFVSkF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 14:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758860AbXFVSjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 14:39:54 -0400
Received: from bjm2.server.18mail.cn ([218.241.65.156]:49494 "EHLO
	bjm1.server.18mail.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757773AbXFVSjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 14:39:54 -0400
Message-ID: <467C1768.1030706@18mail.cn>
Date: Sat, 23 Jun 2007 02:39:36 +0800
From: TripleX <zhongyu@18mail.cn>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Li Yang-r58472 <LeoLi@freescale.com>, Rob Landley <rob@landley.net>,
       gregkh@suse.de, linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com,
       bryan.wu@analog.com, TripleX Chung <xxx.phy@gmail.com>,
       Maggie Chen <chenqi@beyondsoft.com>
Subject: Re: [PATCH] Chinese translation of Documentation/HOWTO
References: <989B956029373F45A0B8AF0297081890D83001@zch01exm26.fsl.freescal e.net> <alpine.LFD.0.98.0706220950110.3593@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706220950110.3593@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-18mail-spam: W 0.00000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Fri, 22 Jun 2007, Li Yang-r58472 wrote:
>   
>> So as I argued in a previous email, non-native English speakers tend to 
>> be more confused by the policies and processes.  I also don't think it's 
>> necessary to translate the technical documents.  To be a software 
>> developer, one has to be educated or experienced in technical terms. 
>> Technical discussion can be done without too much requirement to grammar 
>> and emotional expressing.  The translated document of policies and 
>> processes will help these people to understand the process better and go 
>> smoother in the process.
>>     
>
> I do agree.
>
> I think that the policies and processes parts of the documentation are 
> things that make total sense to encourage translation of, because it's 
> entirely possible that those are interesting and valid even to the people 
> who aren't necessarily directly involved in the actual coding, and may 
> well be relevant to managers etc who may not be _directly_ involed with 
> the rest of the kernel developers.
>
> In fact, I suspect pretty much any documentation (whether technical or 
> about processes and/or style) makes sense to have translated if the energy 
> and ability to do that exists. I suspect the "policies and processes" 
> kinds of docs make _more_ sense to translate initially, simply because 
> they are approachable on their own - but I certainly would never 
> discourage anybody from translating anything at all.
>
> That said, I don't think that merging the result into the standard kernel 
> makes sense - like it or not, right now English ends up being required 
> to be part of actually getting things into the "standard" kernel, and as 
> such, at _some_ point there has to be a connection point that switches 
> over to English, and trying to make the translations be an in-kernel thing 
> is thus kind of pointless.
>
> But as part of some "documentation site", it makes 100% sense. 
>
> And sometimes maybe the issue isn't even just about straight translations, 
> but also perhaps about explaining cultural differences that aren't 
> mentioned at all in the documentation, just because people in the west end 
> up taking certain things for granted and it doesn't "need" documenting..
>
>   
As I know, there are a lot of standalone kernel developer in China. They 
write device drivers for their chips or iptables modules for their  
linux based network devices. They send source files to their customers 
or publish them on web but seldom do anything to make the codes into 
kernel source tree. The usual reason  is they do not know how to 
communicate and work with the Linux kernel development community. People 
will have more chance to read these documentation  if we merge them to 
the kernel source tree.

TripleX

