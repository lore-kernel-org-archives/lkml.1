Return-Path: <linux-kernel-owner+w=401wt.eu-S933293AbYBHD5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933293AbYBHD5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 22:57:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758060AbYBHD5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 22:57:12 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:35020 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758798AbYBHD5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 22:57:11 -0500
Message-ID: <47ABD317.5060805@davidnewall.com>
Date: Fri, 08 Feb 2008 14:27:11 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: Greg KH <greg@kroah.com>, Christer Weinigel <christer@weinigel.se>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
References: <20080125180232.GA4613@kroah.com>	 <20080202123710.42df1aa0@weinigel.se> <20080202191930.GA19826@kroah.com>	 <47A5D9CD.5070001@davidnewall.com>	 <84144f020802030743j1278ac64j2ee3e2cbc5c3fefc@mail.gmail.com>	 <47A5E67D.9040804@davidnewall.com>	 <84144f020802030848v160253feoa24c5ecefc7c91f5@mail.gmail.com>	 <courier.47A8497B.0000472E@hawking.rebel.net.au>	 <1202240590.15090.119.camel@violet>  <47AB0A76.3000404@davidnewall.com> <1202411113.15090.263.camel@violet>
In-Reply-To: <1202411113.15090.263.camel@violet>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcel Holtmann wrote:
> Hi David,
>
>   
>>>>> I think you're missing my point: as long as the license stays the way
>>>>> it is now, you can never distribute proprietary code unless you've
>>>>> consulted a lawyer and even then you run the risk of being sued for
>>>>> infringement if the copyright holder thinks what you have is derived
>>>>> work.
>>>>>       
>>>>>           
>>>> Yes I can, if the proprietary code is not linked with GPL code (and the 
>>>> proprietary code is original).  Loadable modules are not linked.  This is a 
>>>> very clear-cut case.
>>>>     
>>>>         
>>> that is not clear-cut case. You link at run-time. Otherwise the module
>>> would do nothing.
>>>       
>> That's why it's allowed.  The module isn't linked when it's distributed,
>> and the author doesn't do or cause the linking; the user does.  And the
>> user never distributes in the linked state.  Distribution is key to GPL.
>>     
>
> so how do you build this module that is not linked without using the
> Linux kernel.
You could hand code in assembler, using Microsoft's assembler under
Windows.  You could compile from C, using GCC on FreeBSD.  But that's
immaterial.  A module which is an original, non-derivative work, is,
well, original and non-derivative.  Do you say that it must be
otherwise?  Why would that be?
