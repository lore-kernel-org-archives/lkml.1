Return-Path: <linux-kernel-owner+w=401wt.eu-S1762675AbYBOUWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762675AbYBOUWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756977AbYBOUW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:22:28 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:47855 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755578AbYBOUW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:22:27 -0500
Message-ID: <47B5F482.7010702@gentoo.org>
Date: Fri, 15 Feb 2008 21:22:26 +0100
From: =?ISO-8859-1?Q?Ra=FAl_Porcel?= <armin76@gentoo.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [ALPHA] ES40 fails to boot with >=kernel 2.6.23
References: <47B0858A.4090409@gentoo.org> <200802131622.58778.nickpiggin@yahoo.com.au> <20080213154422.GA32748@jurassic.park.msu.ru>
In-Reply-To: <20080213154422.GA32748@jurassic.park.msu.ru>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivan Kokshaysky wrote:
> On Wed, Feb 13, 2008 at 04:22:58PM +1100, Nick Piggin wrote:
>> On Tuesday 12 February 2008 04:27, Raúl Porcel wrote:
>>> We have a Compaq AlphaServer ES40 and since 2.6.23 it won't boot. I'm
>>> attaching the console log and the kernel config.
> 
> Looks like your 'aboot' is outdated - see http://lkml.org/lkml/2007/8/14/259
> 
> I think all distros have an updated aboot package now.
> 
>> Thanks for reporting. I'm not an alpha person, but I have
>> cc'ed them in case they missed this.
> 
> Thanks, I indeed missed that.
> 
> Ivan.


Meh, i replied off-list without noticing, sorry about that.
----------------------------


Correct, that was it. Thing is aboot was patched, but the aboot 
installed on the disk was not.

Thanks :)

Linux monolith 2.6.24 #1 SMP Thu Feb 14 12:10:43 CET 2008 alpha EV68AL 
Tsunami GNU/Linux

Thanks guys :)
