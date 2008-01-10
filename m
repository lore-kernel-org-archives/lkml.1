Return-Path: <linux-kernel-owner+w=401wt.eu-S1756169AbYAJW2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbYAJW2j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 17:28:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758182AbYAJW23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 17:28:29 -0500
Received: from wx-out-0506.google.com ([66.249.82.229]:37943 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757982AbYAJW22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 17:28:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=o4mDaHqzIybwgo7mwj58WG975xwN25mZOsWCMyXgghC5oDZwrKY/oUStqzjEb96keAjGTqEBLxOeCjPYYXGqR26PtczL13nOsOpRi/QOvmmI/wBM9PUS1nYhnXNkrg2Bgs1nwJOimZJp4GPhU5XKjzpAChcKV2/Jkpq1Gr3K2HY=
Message-ID: <e85b9d30801101428s1c760cb1i5ee415738dffb90f@mail.gmail.com>
Date: Thu, 10 Jan 2008 23:28:23 +0100
From: Matthew <jackdachef@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Fwd: Fwd: laptop / computer hardlocks during execution of 32bit applications(binaries) on 64bit system (Gentoo)
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@redhat.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ed Tomlinson" <edt@aei.ca>
In-Reply-To: <478694CB.4000306@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e85b9d30712291157v113f5e73yd830ae3c3429092d@mail.gmail.com>
	 <200712300128.35476.mboton@gmail.com> <20080102084002.GA13636@elte.hu>
	 <e85b9d30801080333y3d6668ccgf20f9666d0326884@mail.gmail.com>
	 <e85b9d30801080340y43fbd4c0sa9b6c9811c7391a1@mail.gmail.com>
	 <47841C41.4060401@zytor.com>
	 <e85b9d30801101310p485c7686o30b7cd581043712@mail.gmail.com>
	 <47868B6D.6030208@zytor.com>
	 <e85b9d30801101352hf66826eqe436e61310c96f14@mail.gmail.com>
	 <478694CB.4000306@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> That's fine, but that was collected with the vmlinux image you sent me,
> right?
>

no, but now it is:
http://kerneloftruth.neucode.org/other/crash_ia32_64/not_tainted/latest/
(the other one was taken before I added/selected the demanded features)

what puzzles me is that it doesn't say "tainted" (not tainted) in the
upper part & "tainted" in the lower part
I apologize for the bad quality of the pictures ...

luckily there was also an additional call trace this time (syslog-ng
Tainted: G   D) (don't know what it means), nvidia-module wasn't
loaded and no other additional proprietary modules were loaded AFAIK

>         -hpa
>

Mat
