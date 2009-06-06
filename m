Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbZFFIKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbZFFIKU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 04:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbZFFIKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 04:10:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:57704 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180AbZFFIKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 04:10:06 -0400
Subject: Re: [PATCH 0/6] headers_check fix patches 20090604
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>, Russell King <rmk+lkml@arm.linux.org.uk>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Tony Luck <tony.luck@intel.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@snapgear.com>, Ralf Baechle <ralf@linux-mips.org>,
       Michael Abbott <michael@araneidae.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1244118232.5172.26.camel@ht.satnam>
References: <1244118232.5172.26.camel@ht.satnam>
Content-Type: text/plain
Date: Sat, 06 Jun 2009 13:40:12 +0530
Message-Id: <1244275812.2475.2.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-04 at 17:53 +0530, Jaswinder Singh Rajput wrote:
> Please Review :
> 
> Jaswinder Singh Rajput (6):
>       headers_check fix: arm, hwcap.h
>       headers_check fix: ia64, fpswa.h
>       headers_check fix: m68k, swab.h
>       headers_check fix: mips, ioctl.h
>       headers_check fix: mn10300, ptrace.h
>       headers_check fix: mn10300, setup.h

Thanks for you review, I applied all these patches to headers-check tree
for linus :

http://git.kernel.org/?p=linux/kernel/git/jaswinder/headers-check-2.6.git;a=summary

Thanks,
--
JSR

