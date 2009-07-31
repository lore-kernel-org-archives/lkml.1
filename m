Return-Path: <linux-kernel-owner+w=401wt.eu-S1752029AbZGaONW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbZGaONW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 10:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbZGaONV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 10:13:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58831 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751807AbZGaONU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 10:13:20 -0400
Date: Fri, 31 Jul 2009 15:14:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "ACPI Devel Maling List" <linux-acpi@vger.kernel.org>,
       "Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?=" <ozan@pardus.org.tr>
Subject: Re: [Bug #13471] Loading parport_pc kills the keyboard if ACPI is
 enabled
Message-ID: <20090731151417.568094e5@lxorguk.ukuu.org.uk>
In-Reply-To: <H5-1lZIIeYK.A.dWH.9XObKB@chimera>
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera>
	<H5-1lZIIeYK.A.dWH.9XObKB@chimera>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Jul 2009 22:45:29 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).


Ozan - can you confirm it broke between 2.6.29 (ie you tested 2.6.29),
and 2.6.30-rc1. If so I have an idea what is going on

Alan

