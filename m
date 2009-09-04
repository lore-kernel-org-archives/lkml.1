Return-Path: <linux-kernel-owner+w=401wt.eu-S934458AbZIDW6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934458AbZIDW6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 18:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934445AbZIDW6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 18:58:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36510 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934420AbZIDW6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 18:58:46 -0400
Message-ID: <4AA19AAE.9050909@zytor.com>
Date: Fri, 04 Sep 2009 15:54:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, mingo@redhat.com, sam@ravnborg.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/kbuild] x86: Don't silently override CONFIG_64BIT in
 'make oldconfig'
References: <tip-5a8a2d13b1526e306ff2a9fe12dc9d5878d355f9@git.kernel.org>	 <20090904144857.GA12872@elte.hu>	 <alpine.LFD.2.00.0909041631210.14872@twosheds.infradead.org>	 <4AA13FE6.20807@zytor.com>	 <20090904093846.a87bd198.randy.dunlap@oracle.com> <1252100456.4483.544.camel@macbook.infradead.org>
In-Reply-To: <1252100456.4483.544.camel@macbook.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2009 02:40 PM, David Woodhouse wrote:
> On Fri, 2009-09-04 at 09:38 -0700, Randy Dunlap wrote:
>>
>> what does ARCH=x86 mean?
> 
> A bit like ARCH=powerpc. It's the new combined architecture where 64-bit
> vs. 32-bit is just a config choice. ARCH=i386 and ARCH=x86_64 are just
> historical baggage, and should be dropped like ARCH=ppc and ARCH=ppc64
> were.
> 

>From a cursory look it looks like ARCH=powerpc won't work for UM, either.

	-hpa

