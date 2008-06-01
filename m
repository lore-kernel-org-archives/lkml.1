Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbYFAALJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbYFAALJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 20:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbYFAAK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 20:10:57 -0400
Received: from aun.it.uu.se ([130.238.12.36]:44566 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754463AbYFAAK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 20:10:56 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18497.59633.817344.933052@harpo.it.uu.se>
Date: Sun, 1 Jun 2008 02:10:25 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Mikael Pettersson" <mikpe@it.uu.se>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>
Subject: Re: [Bug #10822] sky2 oops in 2.6.26-rc3
In-Reply-To: <UJSav77TyUB.A.WKD.vqZQIB@albercik>
References: <90LLR3uLHfN.A.NZC.LqZQIB@albercik>
	<UJSav77TyUB.A.WKD.vqZQIB@albercik>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 May 2008 19:48:06 +0200 (CEST), Rafael J. Wysocki wrote:
>This message has been generated automatically as a part of a report
>of recent regressions.
>
>The following bug entry is on the current list of known regressions
>from 2.6.25.  Please verify if it still should be listed.
>
>
>Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D10822
>Subject		: sky2 oops in 2.6.26-rc3
>Submitter	: Mikael Pettersson <mikpe@it.uu.se>
>Date		: 2008-05-25 17:27 (7 days old)
>References	: http://marc.info/?l=3Dlinux-netdev&amp;m=3D121173650915153&amp=
>;w=3D4
>Handled-By	: Stephen Hemminger <shemminger@linux-foundation.org>

It's a one-off crash that hasn't happened since I reported it.
And the fact that it happended while I was running 2.6.26-rc3
may just be coincidental and/or caused by temperamental HW.

My intention was never to classify this as a regression, I
just wanted to report a failure data point in case a pattern
emerges.
