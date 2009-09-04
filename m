Return-Path: <linux-kernel-owner+w=401wt.eu-S933721AbZIDQ6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933721AbZIDQ6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 12:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932871AbZIDQ6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 12:58:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42308 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932706AbZIDQ6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 12:58:30 -0400
Message-ID: <4AA14618.9010505@zytor.com>
Date: Fri, 04 Sep 2009 09:53:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, mingo@redhat.com, sam@ravnborg.org,
       tglx@linutronix.de, David.Woodhouse@intel.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/kbuild] x86: Don't silently override CONFIG_64BIT in
 'make oldconfig'
References: <tip-5a8a2d13b1526e306ff2a9fe12dc9d5878d355f9@git.kernel.org>	<20090904144857.GA12872@elte.hu>	<alpine.LFD.2.00.0909041631210.14872@twosheds.infradead.org>	<4AA13FE6.20807@zytor.com> <20090904093846.a87bd198.randy.dunlap@oracle.com>
In-Reply-To: <20090904093846.a87bd198.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2009 09:38 AM, Randy Dunlap wrote:
>>>
>> Quite possible.  ARCH=x86 hasn't exactly been widely used.
> 
> what does ARCH=x86 mean?
> 

Treat 32 vs 64 bit as a normal Kconfig variable.  Similar as for other
32/64-bit architectures.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

