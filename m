Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbYIAVRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbYIAVRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 17:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbYIAVRB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 17:17:01 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:5407 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbYIAVQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 17:16:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=HGWhISqsVbEI+2KiIPRh3D6z59k7/Iut2Aa01iYRsE5rEkDP7XjmZq9I/uZ7XzLwrf
         aIZIwpyV5e8FqleruV8hBEvJgxzL4rh6lmvxIrWcPanUC1ud0xXOeXcyfo3OhvcLNtSa
         hyJ++tFGn/mjWmAA7pvB6YAw2iyqx9fuDSEoI=
Date: Tue, 2 Sep 2008 00:46:24 +0400
From: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [Bug #11191] 2.6.26-git8: spinlock lockup in c1e_idle()
Message-ID: <20080902004624.61f39cfe@gmail.com>
In-Reply-To: <N8SeMoDzuxC.A.TJH.klbuIB@albercik>
References: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
	<N8SeMoDzuxC.A.TJH.klbuIB@albercik>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Aug 2008 21:50:13 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11191
> Subject		: 2.6.26-git8: spinlock lockup in c1e_idle()
> Submitter	: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
> Date		: 2008-07-24 03:22 (38 days old)
> References	: http://lkml.org/lkml/2008/7/23/317
> Handled-By	: Thomas Gleixner <tglx@linutronix.de>
> 
> 

not fixed yet
