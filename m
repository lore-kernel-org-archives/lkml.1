Return-Path: <linux-kernel-owner+w=401wt.eu-S1759300AbYC0KK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300AbYC0KK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 06:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbYC0KKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 06:10:13 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:54919
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755491AbYC0KKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 06:10:12 -0400
Message-ID: <47EB7281.6070300@qumranet.com>
Date: Thu, 27 Mar 2008 12:10:09 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: [kvm-devel] kvm causing memory corruption?  ~2.6.25-rc6
References: <1206479576.7562.21.camel@nimitz.home.sr71.net>	 <47EA1C63.8010202@qumranet.com>	 <1206550329.7883.5.camel@nimitz.home.sr71.net>	 <47EA80AC.4070204@qumranet.com> <1206551794.7883.7.camel@nimitz.home.sr71.net> <47EB6AAC.3040607@qumranet.com>
In-Reply-To: <47EB6AAC.3040607@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Dave Hansen wrote:
>> On Wed, 2008-03-26 at 18:58 +0200, Avi Kivity wrote:
>>  
>>> Dave Hansen wrote:
>>>    
>>>> On Wed, 2008-03-26 at 11:50 +0200, Avi Kivity wrote:
>>>>      
>>>>> Dave Hansen wrote:
>>>>>            
>>>>>> I was getting some kvm userspace crashes trying to run a Windows 
>>>>>> guest.
>>>>>> So, I decided to try a recent kernel (2.6.25-rc6-00333-ga4083c9)  
>>>>>> with
>>>>>> the kvm kernel code that shipped with that kernel.
>
[...]


btw, is this with >= 4GB RAM on the host?

-- 
error compiling committee.c: too many arguments to function

