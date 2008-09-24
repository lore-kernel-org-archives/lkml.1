Return-Path: <linux-kernel-owner+w=401wt.eu-S1752906AbYIXBT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbYIXBT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 21:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbYIXBTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 21:19:18 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:45769 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbYIXBTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 21:19:17 -0400
Subject: Re: [Bug #11548] kernel BUG at drivers/pci/intel-iommu.c:1373!
From: Chris Mason <chris.mason@oracle.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <7lIhZC4hCxE.A.oAH.j0q1IB@albercik>
References: <PJz8fNrJNHG.A.65F.wzq1IB@albercik>
	 <7lIhZC4hCxE.A.oAH.j0q1IB@albercik>
Content-Type: text/plain
Date: Tue, 23 Sep 2008 21:18:41 -0400
Message-Id: <1222219121.7160.162.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-09-21 at 20:54 +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 

I'm unable to reproduce this on 2.6.27-rc7.  I don't think it has been
fixed, but I'm having a hard time finding a reliable way to trigger it
on newer kernels.

-chris


