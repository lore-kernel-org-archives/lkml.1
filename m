Return-Path: <linux-kernel-owner+w=401wt.eu-S1760770AbXHBUvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760770AbXHBUvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 16:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754920AbXHBUvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 16:51:40 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:39300 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbXHBUvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 16:51:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fcVyNd5oOnRNlHI/jVWgXC+CZKDq4hLan4CdpQnrIFayHzbRjpUx4QvoSOTUo9U+oqGQ6eB1Y3jRxi/MTDgVdqTHs1X1oYcPP7X0WItERo6Io0Th4YWd9TWe4ZDmp8Ej+oiRURfw1UTbw1krBp69O0ABtXCMOF49Uno9rKI9qUw=
Message-ID: <5ebbd9b50708021351r4a2a00e9lc7d1968259e964dc@mail.gmail.com>
Date: Thu, 2 Aug 2007 20:51:38 +0000
From: "Frank Hale" <frankhale@gmail.com>
To: "Cal Peake" <cp@absolutedigital.net>
Subject: Re: ACPI on Averatec 2370
Cc: "Chuck Ebbert" <cebbert@redhat.com>,
       "Gabriel C" <nix.or.die@googlemail.com>,
       "Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel ACPI Mailing List" <linux-acpi@vger.kernel.org>,
       len.brown@intel.com, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <Pine.LNX.4.64.0708021627590.28012@lancer.cnet.absolutedigital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5ebbd9b50707291105w316f98e5h3fa17204c9119a2f@mail.gmail.com>
	 <46ACD8DB.2020108@googlemail.com>
	 <Pine.LNX.4.64.0707301048460.5693@lancer.cnet.absolutedigital.net>
	 <Pine.LNX.4.64.0708021335060.28012@lancer.cnet.absolutedigital.net>
	 <46B22BDA.8090604@redhat.com>
	 <Pine.LNX.4.64.0708021512530.28012@lancer.cnet.absolutedigital.net>
	 <46B23E08.4070106@redhat.com>
	 <Pine.LNX.4.64.0708021627590.28012@lancer.cnet.absolutedigital.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here is my /proc/cpuinfo, I have SMP disabled at the moment. Looks
like my model is slightly older than Cal's.

processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 72
model name      : AMD Turion(tm) 64 X2 Mobile Technology TL-50
stepping        : 2
cpu MHz         : 800.000
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
fxsr_opt rdtscp lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm
extapic cr8legacy ts fid vid ttp tm stc
bogomips        : 1609.36
clflush size    : 64
