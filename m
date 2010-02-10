Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab0BJSpL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 13:45:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39013 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755181Ab0BJSpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 13:45:06 -0500
Message-ID: <4B72FDE1.8060609@zytor.com>
Date: Wed, 10 Feb 2010 10:41:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Jan Engelhardt <jengelh@medozas.de>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       virtualization@lists.osdl.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Paravirt compile failure with gcc33
References: <alpine.LSU.2.01.1002101909560.29808@obet.zrqbmnf.qr> <4B72FD09.1020202@goop.org>
In-Reply-To: <4B72FD09.1020202@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2010 10:38 AM, Jeremy Fitzhardinge wrote:
> On 02/10/2010 10:13 AM, Jan Engelhardt wrote:
>> As I was compile-testing 2.6.33-rc with gcc-3.3,
>> binutils-2.19.51-10.26.4.x86_64, I observed a failure when
>> CONFIG_PARAVIRT is turned on:
>>    
> 
> Yeah, there's a gcc bug of some kind there, and its very hard to see how 
> to work around it.  When we last discussed this, I think we were close 
> to deciding to obsolete gcc 3.3.
> 
> HPA, do you remember?
> 

I don't, and the macros are tangled enough that I'm not actually sure
what the failure really is.

	-hpa
