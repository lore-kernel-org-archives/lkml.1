Return-Path: <linux-kernel-owner+w=401wt.eu-S1754958AbYJLVxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbYJLVxQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 17:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbYJLVxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 17:53:00 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:27960 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbYJLVw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 17:52:59 -0400
Message-ID: <48F2718E.6010803@oracle.com>
Date: Sun, 12 Oct 2008 14:52:14 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: Re: [Bug #11404] BUG: in 2.6.23-rc3-git7 in do_cciss_intr
References: <0pOgGB.A.uLG.E475IB@wind> <yWwteD.A.0r.j675IB@wind>
In-Reply-To: <yWwteD.A.0r.j675IB@wind>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11404
> Subject		: BUG: in 2.6.23-rc3-git7 in do_cciss_intr
> Submitter	: rdunlap <randy.dunlap@oracle.com>
> Date		: 2008-08-21 5:52 (45 days old)
> References	: http://marc.info/?l=linux-kernel&m=121929819616273&w=4
> 		  http://marc.info/?l=linux-kernel&m=121932889105368&w=4
> Handled-By	: Miller, Mike (OS Dev) <Mike.Miller@hp.com>
> 		  James Bottomley <James.Bottomley@hansenpartnership.com>

Also happened with 2.6.27-git2.

-- 
~Randy
