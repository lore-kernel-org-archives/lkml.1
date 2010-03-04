Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab0CDT3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 14:29:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:47127 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756188Ab0CDT3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 14:29:21 -0500
Message-ID: <4B9009D4.8060404@kernel.org>
Date: Thu, 04 Mar 2010 11:28:20 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: no boot with NO_BOOTMEM=y [was: mmotm 2010-03-02-18-38 uploaded]
References: <201003030305.o2335F1F015917@imap1.linux-foundation.org> <4B8FC98E.3070203@gmail.com> <4B8FCC4D.6040202@gmail.com>
In-Reply-To: <4B8FCC4D.6040202@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2010 07:05 AM, Jiri Slaby wrote:
> Subject fixed.
> 
> On 03/04/2010 03:54 PM, Jiri Slaby wrote:
>> On 03/03/2010 03:39 AM, akpm@linux-foundation.org wrote:
>>> The mm-of-the-moment snapshot 2010-03-02-18-38 has been uploaded to
>>
>> Hi, the kernel does not boot in qemu-kvm with NO_BOOTMEM=y. The last
>> message is 'Booting the kernel.'
> 

can you check current linus tree or tip/master?

also can you send out .config?

Thanks

Yinghai
