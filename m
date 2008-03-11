Return-Path: <linux-kernel-owner+w=401wt.eu-S1752347AbYCKQha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbYCKQha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 12:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbYCKQhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 12:37:18 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:2346 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbYCKQhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 12:37:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qhlfRci6HnE6yTZltxCJTygprgdC4wvaSeFSbhKflBpBJ6Qv+MvxOr1XYrOlLaijL0QdITy1m/WneYLFv0D9QGRWaC9NgebGT+e5OG9VQvrJIxnMekn8/QdNjI7/hPcJ1/c/EC8WcCNCHZjZCQEMZ4CK+/4XcudMcIB7ll2OtpA=
Message-ID: <7c86c4470803110937u7e4625d8ubc6250b7ba730f2b@mail.gmail.com>
Date: Tue, 11 Mar 2008 09:37:16 -0700
From: "stephane eranian" <eranian@googlemail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 0/3] perfmon x86 infrastructure definitions (take 2)
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       ak@suse.de, tglx@linutronix.de
In-Reply-To: <20080310075251.GA17657@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7c86c4470803071305t5d4e581fs66e9fe8288d0392@mail.gmail.com>
	 <20080310075251.GA17657@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Thanks. Will send the PCI id patch to Greg KH.


On Mon, Mar 10, 2008 at 12:52 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * stephane eranian <eranian@googlemail.com> wrote:
>
>  > Hello,
>  >
>  > Take 2: correct titles and no attachment.
>
>  note, all the patches were whitespace damaged (all tabs were spaces). I
>  fixed this up by hand but please check Documentation/email-clients.txt.
>
>
>  > Here is a small set of patches for x86. They are used by perfmon but
>  > they can be applied independently.
>  >
>  > patch 1: adds cpu_has_arch_perfmon to cpufeature macros to test for
>  > architectural perfmon  on Intel processors
>  > patch 2: adds AMD Northbridge config MSR definition
>  > patch 3: adds AMD Northbridge PCI Id
>
>  i've added all three to x86.git for convenience, but the PCI ID will
>  need to go via Greg KH's PCI tree i suspect.
>
>         Ingo
>
