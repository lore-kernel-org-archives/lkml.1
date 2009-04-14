Return-Path: <linux-kernel-owner+w=401wt.eu-S1755376AbZDNQQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbZDNQQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbZDNQQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:16:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:46740 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755937AbZDNQQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:16:07 -0400
Subject: Re: [PATCH -tip] x86: kernel-parameters replace X86-32,X86-64 with
 X86
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <49E4B2CC.3060005@oracle.com>
References: <1239698023.3033.37.camel@ht.satnam>
	 <49E4B2CC.3060005@oracle.com>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 21:45:30 +0530
Message-Id: <1239725730.2966.12.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Randy,

On Tue, 2009-04-14 at 08:59 -0700, Randy Dunlap wrote:
> Jaswinder Singh Rajput wrote:
> > X86 is same as X86-32+X86-64 so replacing X86-32,X86-64 with X86
> 
> That's all good, thanks.
> 

Thanks, this patch is applied to -tip:
http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commit;h=6cececfcece2b072d29886ed7140495f3af17153

> There is still one instance of "i386" that should be changed.
> This should become just [X86]:
> 
> 	enable_timer_pin_1 [i386,x86-64]

If you want, you can fix this along with your other Documentation
patches :-)

Thanks,

--
JSR

