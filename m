Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbYAJVwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbYAJVwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 16:52:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbYAJVwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 16:52:35 -0500
Received: from wx-out-0506.google.com ([66.249.82.231]:9187 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbYAJVwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 16:52:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=yCek/AB3jqDNysaqQJDFQEQC7BAWiUm6TAcedbKGn8qn/ss97a0skCc43X01ivJtjkRVSFUZ5ReQQc51wXKKlpxWPq93OpB7X8vDlkFF2bINn1J51PktUSoRAQLk6KqiWla24EgRFdoi0MTMXK/Aw8afUVEutv9e+S7V40oePb4=
Message-ID: <e85b9d30801101352hf66826eqe436e61310c96f14@mail.gmail.com>
Date: Thu, 10 Jan 2008 22:52:31 +0100
From: Matthew <jackdachef@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Fwd: Fwd: laptop / computer hardlocks during execution of 32bit applications(binaries) on 64bit system (Gentoo)
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@redhat.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ed Tomlinson" <edt@aei.ca>
In-Reply-To: <47868B6D.6030208@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e85b9d30712291157v113f5e73yd830ae3c3429092d@mail.gmail.com>
	 <e85b9d30712291504r2f4ef991w33f501ccf0d41c2b@mail.gmail.com>
	 <200712300128.35476.mboton@gmail.com> <20080102084002.GA13636@elte.hu>
	 <e85b9d30801080333y3d6668ccgf20f9666d0326884@mail.gmail.com>
	 <e85b9d30801080340y43fbd4c0sa9b6c9811c7391a1@mail.gmail.com>
	 <47841C41.4060401@zytor.com>
	 <e85b9d30801101310p485c7686o30b7cd581043712@mail.gmail.com>
	 <47868B6D.6030208@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Do you have the error dump output to go along with this, too?
>

no, unfortunately no kernel crash dump on disk ;( (I hope I understood
it right, I'm pretty noobish concerning collection of error data ;) )

I only have the console-output of the hardlock in:
http://kerneloftruth.neucode.org/other/crash_ia32_64/not_tainted/

and a call trace from an earlier crash but I don't know if it's worth anything:
http://kerneloftruth.neucode.org/other/crash_ia32_64/moto_0040.jpg

just FYI: the crash also occurs with preemptible rcu disabled (classic
rcu) (just saw that I had it enabled in that kernel ...)


> Huge thanks,
>

:)

>         -hpa
>

Mat
