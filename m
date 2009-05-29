Return-Path: <linux-kernel-owner+w=401wt.eu-S1754620AbZE2Vbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbZE2Vbf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 17:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbZE2Vb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 17:31:27 -0400
Received: from claw.goop.org ([74.207.240.146]:33283 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313AbZE2Vb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 17:31:27 -0400
Message-ID: <4A20542A.8020407@goop.org>
Date: Fri, 29 May 2009 14:31:22 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: George Dunlap <george.dunlap@eu.citrix.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: Xen is a feature
References: <162f4c90-6431-4a2a-b337-6d7451d7b11e@default>	<20090528001350.GD26820@elte.hu> <4A1F302E.8030501@goop.org>	<20090528.210559.137121893.davem@davemloft.net>	<4A1FCE8E.2060604@eu.citrix.com> <87tz33ep1b.fsf@basil.nowhere.org>
In-Reply-To: <87tz33ep1b.fsf@basil.nowhere.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> George Dunlap <george.dunlap@eu.citrix.com> writes:
>
> cc list from hell trimmed. 
>
>   
>> allowing Linux to run as dom0 *is* improving Linux.  The lack of dom0
>> support is at this moment making life more difficult for a huge number
>> of Linux users who use Xen, including Mozilla, Debian, and Amazon.
>> Adding dom0 support would make Linux even more useful to a wide
>> variety of people not using Xen at the moment.
>>     
>
> Perhaps one way to address this problem would be to make the Dom0
> interface less intrusive for the host OS?
>   

I'm certainly not deaf to criticism along those lines, and I'm looking 
at ways of cleaning up/decoupling those interactions.

But my frustration arises from the fact that there's been a total stall 
on merging any of the pieces, even the ones which are either 
uncontroversial, or purely xen-internal changes.

    J
