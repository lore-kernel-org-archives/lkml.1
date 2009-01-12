Return-Path: <linux-kernel-owner+w=401wt.eu-S1757794AbZALVza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794AbZALVza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 16:55:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbZALVzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 16:55:10 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:43253 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbZALVzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 16:55:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=F0pgZT5ETsb9zKHLJrg1rmAp7G9+QX98SPsGNOz99aKNl0hn/BUflpp1kfL2H8okMq
         OXiYTmDa7E2zDNi6f1or4RpkaABoZ0w75bO3Sv+18kiLmHB8nV8nas61V8cyCiX/aXdz
         FQr0UrJv4AJ2hxAlq0mAj/BplqseA2jUhPpCA=
Message-ID: <64bb37e0901121355o78815c9dp5d4753c04886adc7@mail.gmail.com>
Date: Mon, 12 Jan 2009 22:55:06 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [git pull] x86 fixes
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20090112205259.GA5303@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090111143951.GA6666@elte.hu>
	 <64bb37e0901110845o2561db4auf68b86d024d210a0@mail.gmail.com>
	 <7E82351C108FA840AB1866AC776AEC4643BB73C5@orsmsx505.amr.corp.intel.com>
	 <64bb37e0901121101y73c492fel38a70681f226b526@mail.gmail.com>
	 <20090112191934.GA28851@linux-os.sc.intel.com>
	 <20090112192912.GA31650@linux-os.sc.intel.com>
	 <alpine.LFD.2.00.0901121145220.6528@localhost.localdomain>
	 <20090112205259.GA5303@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 9:52 PM, Ingo Molnar <mingo@elte.hu> wrote:
> The reason why we wanted to re-test the functional changes was that
> Torsten's crash looks very weird: double Call Trace line, a crash in the
> scsi/ata code, showing the after-effects of some sort of memory corruption
> there.

The double Call Trace: line was a copy&paste error on my part. Its not
there in the original oops.

Sorry for that...

Torsten
