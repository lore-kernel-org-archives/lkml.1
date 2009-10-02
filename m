Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbZJBRWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbZJBRWG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 13:22:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757561AbZJBRWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 13:22:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860AbZJBRWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 13:22:04 -0400
Message-ID: <4AC635D5.8080809@zytor.com>
Date: Fri, 02 Oct 2009 10:18:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: "Wang, Shane" <shane.wang@intel.com>
CC: Pavel Machek <pavel@ucw.cz>, Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Cihula, Joseph" <joseph.cihula@intel.com>
Subject: Re: [GIT PULL] x86/txt for v2.6.32
References: <200909142051.n8EKpiOM017912@terminus.zytor.com> <200909262344.21257.rjw@sisk.pl> <20090928210252.GD1960@elf.ucw.cz> <200909282307.56190.rjw@sisk.pl> <4AC1267D.6020405@zytor.com> <20090928211745.GA2119@elf.ucw.cz> <4AC1AA61.8070408@intel.com> <20090929171318.GC14405@elf.ucw.cz> <20090929191951.18315e94@infradead.org> <037F493892196B458CD3E193E8EBAD4F01ED9FE3B1@pdsmsx502.ccr.corp.intel.com> <20090930065448.GB11652@elf.ucw.cz> <037F493892196B458CD3E193E8EBAD4F01ED9FE6E3@pdsmsx502.ccr.corp.intel.com>
In-Reply-To: <037F493892196B458CD3E193E8EBAD4F01ED9FE6E3@pdsmsx502.ccr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2009 10:02 AM, Wang, Shane wrote:
>> So I modify the RAM content so that BIOS does not think measured
>> environment existed before suspend?
>> 									Pavel
> 
> Hi Pavel, what do you mean on this question? 
> When do you modify the RAM? before S3 sleep?
> 

He was talking earlier about a liquid nitrogen freeze attack.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

