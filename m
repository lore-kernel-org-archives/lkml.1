Return-Path: <linux-kernel-owner+w=401wt.eu-S1761444AbYH3Vjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761444AbYH3Vjp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 17:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758922AbYH3V3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 17:29:50 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:56432 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759289AbYH3V3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 17:29:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TgbDtxdIcipzD7F3R9a2fz6z+Kb70p3dYbN04ieelHwylzersMHCzrTyjr6wlewavl
         KQi2kOJlnGAPOtvUaxDPnBbaG1D+o7FXzkgqSFgUDiQC9m3eW/15ilZy9kG765mh6H/s
         7IO0Z7zH9rTvCBdyKVZMq2rx65jkw2y/3bW+k=
Message-ID: <86802c440808301429u2a719571raf0d8001a89a1388@mail.gmail.com>
Date: Sat, 30 Aug 2008 14:29:47 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #11388] 2.6.27-rc3 warns about MTRR range; only 3 of 16gb of memory is usable
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Joshua Hoblitt" <j_kernel@hoblitt.com>
In-Reply-To: <N8SeMoDzuxC.A.8uE.libuIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
	 <N8SeMoDzuxC.A.8uE.libuIB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2008 at 12:50 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=11388
> Subject         : 2.6.27-rc3 warns about MTRR range; only 3 of 16gb of memory is usable
> Submitter       : Joshua Hoblitt <j_kernel@hoblitt.com>
> Date            : 2008-08-20 17:38 (11 days old)
>
>
>

this should be closed

commit	38cc1c3df77c1bb739a4766788eb9fa49f16ffdf
x86: work around MTRR mask setting

fixed it.

YH
