Return-Path: <linux-kernel-owner+w=401wt.eu-S1753361AbZKQGEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbZKQGEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 01:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031AbZKQGET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 01:04:19 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:45729 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbZKQGES convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 01:04:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DREoVfaBdAMH7eB4Mpi7TrA006Xk/pUvdBnjx4wvJy/84OTjWLPsIiGXSbILn44cUV
         OhZ5RDLFWEyYobEqx/UMjgFS0Zo2+VMj5MlZCQXvYVQ38o8VV8YLGKrJVAd2S2OrQuwT
         P+gWOgdyQ7RA68P8GXPWx9KFNcf3zpGtzVr50=
MIME-Version: 1.0
In-Reply-To: <xXQGFmujPl.A.o1.bUdALB@chimera>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera> <xXQGFmujPl.A.o1.bUdALB@chimera>
Date: Tue, 17 Nov 2009 07:04:10 +0100
Message-ID: <8db1092f0911162204i36dbd472w1d2c88411e151acb@mail.gmail.com>
Subject: Re: [Bug #14352] WARNING: at net/mac80211/scan.c:267
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/11/16 Rafael J. Wysocki <rjw@sisk.pl>:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14352
> Subject         : WARNING: at net/mac80211/scan.c:267
> Submitter       : Maciej Rutecki <maciej.rutecki@gmail.com>
> Date            : 2009-10-08 00:30 (40 days old)
> References      : http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2089#c7
>
>

In 2.6.32-rc7 problem seems be fixed.

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
