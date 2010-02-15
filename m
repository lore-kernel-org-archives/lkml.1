Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab0BOGyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 01:54:14 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:41759 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab0BOGyN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 01:54:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bcNo4Iw84+JyOY/q6pMWlNE6wAzyG+mcjD5SRBQ1SV7hz/r8/yKxui2ZltQRk3661a
         I5sraTksonmR+uMlHHToObBb1RjRNsglctI3flLyjiuMe6MWAz43hwRRwBHedqUE5+tO
         cB+cfKTkAAbKm40MB2Cm5phfzYWKfTqQcOm/o=
MIME-Version: 1.0
In-Reply-To: <Xv2rBFCTXTH.A.DTC.vyIeLB@chimera>
References: <fQEllunEdO.A.-LB.HyIeLB@chimera>
	 <Xv2rBFCTXTH.A.DTC.vyIeLB@chimera>
Date: Mon, 15 Feb 2010 07:54:11 +0100
Message-ID: <b170af451002142254w5c6656eegdee2431b0146d3f8@mail.gmail.com>
Subject: Re: [Bug #15096] Resume lock up -- bisected, commit 
	3a1151e3f124fd1a2c54b8153f510f1a7c715369
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Len Brown <len.brown@intel.com>,
       Stefan Bader <stefan.bader@canonical.com>,
       Zhang Rui <rui.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/2/15 Rafael J. Wysocki <rjw@sisk.pl>:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let the tracking team know (either way).

It should be, there is one testing request I didn't make yet. I'll do
this soon, after my today's study final exam.

-- 
Rafał
