Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbYFYKlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbYFYKlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 06:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbYFYKlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 06:41:09 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:55486 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371AbYFYKlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 06:41:08 -0400
Message-ID: <486220C2.1090809@aitel.hist.no>
Date: Wed, 25 Jun 2008 12:41:06 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
Organization: HiST
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug #10962] 2.6.26-rc2 WARNING from usb-serial, and then my
 gps is dead
References: <RzbtSgMztjP.A.jRD._spXIB@albercik> <4mRZUF-hVeG.A.hVD.DtpXIB@albercik>
In-Reply-To: <4mRZUF-hVeG.A.hVD.DtpXIB@albercik>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10962
> Subject		: 2.6.26-rc2 WARNING from usb-serial, and then my gps is dead
> Submitter	: Helge Hafting <helge.hafting@aitel.hist.no>
> Date		: 2008-06-22 18:22 (1 days old)
> References	: http://marc.info/?l=linux-kernel&m=121415899320685&w=4
> 
> 

I can confirm that this problem still happens in 2.6.26-rc8.
When the gps loose connection (probably due to faulty USB cabling), then
the kernel spits out numerous WARNINGs.

I'll try to reproduce with USB debugging later.

Helge Hafting

