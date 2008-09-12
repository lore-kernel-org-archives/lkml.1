Return-Path: <linux-kernel-owner+w=401wt.eu-S1761471AbYILVBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761471AbYILVBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 17:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759176AbYILU4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 16:56:37 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:47553 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760596AbYILU4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 16:56:35 -0400
Subject: Re: [Bug #11548] kernel BUG at drivers/pci/intel-iommu.c:1373!
From: Chris Mason <chris.mason@oracle.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <SpS7rta8n4.A.PRG.8bsyIB@albercik>
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
	 <SpS7rta8n4.A.PRG.8bsyIB@albercik>
Content-Type: text/plain
Date: Fri, 12 Sep 2008 16:56:29 -0400
Message-Id: <1221252989.8709.11.camel@think.oraclecorp.com>
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

On Fri, 2008-09-12 at 21:06 +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 

This is still a bug, but I haven't tried this workload on 2.6.26, so I'm
not sure it is a regression.  Unfortunately, I won't be able to test it
again until after the plumber's conference.

-chris


