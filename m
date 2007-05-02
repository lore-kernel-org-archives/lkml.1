Return-Path: <linux-kernel-owner+w=401wt.eu-S1767196AbXEBXIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767196AbXEBXIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 19:08:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767201AbXEBXIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 19:08:11 -0400
Received: from [212.12.190.4] ([212.12.190.4]:32970 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1767196AbXEBXIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 19:08:09 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [ck] [REPORT] 2.6.21.1 vs 2.6.21-sd046 vs 2.6.21-cfs-v6
Date: Thu, 3 May 2007 02:11:39 +0300
User-Agent: KMail/1.5
Cc: ck@vds.kolivas.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200705030211.39345.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
> On Monday 30 April 2007 18:05, Michael Gerdau wrote:
> > meanwhile I've redone my numbercrunching tests with the following
> > kernels: 2.6.21.1 (mainline)
> >     2.6.21-sd046
> >     2.6.21-cfs-v6
> > running on a dualcore x86_64.
> > [I will run the same test with 2.6.21.1-cfs-v7 over the next days,
> > likely tonight]
:
:
> > However from these figures it seems as if sd does provide for the
> > fairest (as in equal share for all) scheduling among the 3 schedulers
> > tested.
>
> Looks good, thanks. Ingo's been hard at work since then and has v8 out by
> now. SD has not changed so you wouldn't need to do the whole lot of tests
> on SD again unless you don't trust some of the results.

Well, I tried cfs-v8 and it still shows some nice regressions wrt 
mainline/sd.  SD's nice-levels look rather solid, implying fairness.


Thanks!

--
Al

