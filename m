Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725Ab0AXWo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab0AXWo4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 17:44:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728Ab0AXWop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 17:44:45 -0500
Received: from mail-ew0-f226.google.com ([209.85.219.226]:50357 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759Ab0AXWol convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 17:44:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RMbbKhJIKE72SwRVQvuzc6aEZdSRtT7i0BEg7WrQjCfZpsLuZooNUbnY2v7x7VDmhj
         nXzcHtMjHuMDtNKO3rvB1b/y7L8+FyzLAPvezFABEzUYRZkMmo92m2esUlSMxYghnkSF
         +SVn40J1X3BUo82MpinzQmXJJsJd5q8kEQlKg=
MIME-Version: 1.0
In-Reply-To: <q60Z28d_9yH.A.QkH.LZMXLB@chimera>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
	 <q60Z28d_9yH.A.QkH.LZMXLB@chimera>
Date: Sun, 24 Jan 2010 23:44:40 +0100
Message-ID: <b170af451001241444u449d5be6i194b825ff7f5e02e@mail.gmail.com>
Subject: Re: [Bug #15096] Resume lock up -- bisected, commit 
	3a1151e3f124fd1a2c54b8153f510f1a7c715369
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Len Brown <len.brown@intel.com>,
       Stefan Bader <stefan.bader@canonical.com>,
       Zhang Rui <rui.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/24 Rafael J. Wysocki <rjw@sisk.pl>:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15096
> Subject         : Resume lock up -- bisected, commit 3a1151e3f124fd1a2c54b8153f510f1a7c715369
> Submitter       : Rafał Miłecki <zajec5@gmail.com>
> Date            : 2010-01-20 23:15 (5 days old)

Still should be, didn't hear about any fix, didn't see any.

-- 
Rafał
