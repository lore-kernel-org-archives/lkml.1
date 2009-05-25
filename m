Return-Path: <linux-kernel-owner+w=401wt.eu-S1754435AbZEYIWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbZEYIWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 04:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbZEYIV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 04:21:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:40272 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbZEYIV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 04:21:56 -0400
Subject: Re: [Bug #13126] BUG: MAX_LOCKDEP_ENTRIES too low! when mounting
 rootfs
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Philip Copeland <bryce@zeniv.linux.org.uk>
In-Reply-To: <uSztiUhmDDC.A.I2B.y-bGKB@chimera>
References: <ZPPBiNHr1LC.A.9ZH.K9bGKB@chimera>
	 <uSztiUhmDDC.A.I2B.y-bGKB@chimera>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 25 May 2009 10:21:58 +0200
Message-Id: <1243239718.26820.647.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-05-24 at 21:11 +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13126
> Subject		: BUG: MAX_LOCKDEP_ENTRIES too low! when mounting rootfs
> Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
> Date		: 2009-04-15 12:43 (40 days old)
> References	: http://marc.info/?l=linux-kernel&m=123979949820538&w=4

-rc7 includes:

Ingo Molnar (1):
      lockdep: increase MAX_LOCKDEP_ENTRIES and MAX_LOCKDEP_CHAINS

Which can be found with commit id: 
   d80c19df5fcceb8c741e96f09f275c2da719efef




