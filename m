Return-Path: <linux-kernel-owner+w=401wt.eu-S932708AbXLOOFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932708AbXLOOFp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 09:05:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756725AbXLOOFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 09:05:38 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:44015 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbXLOOFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 09:05:37 -0500
Date: Sat, 15 Dec 2007 09:05:32 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
cc: shannon.nelson@intel.com, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, trem <tremyfr@yahoo.fr>
Subject: Re: [PATCH][RT] 2.6.24-rc5-rt1 drivers/dma/ioat_dma.c compile fix
In-Reply-To: <1197690973.12832.12.camel@sx.thebigcorporation.com>
Message-ID: <Pine.LNX.4.58.0712150904400.10448@gandalf.stny.rr.com>
References: <BAE9DCEF64577A439B3A37F36F9B691C0371E3E3@orsmsx418.amr.corp.intel.com>
  <Pine.LNX.4.58.0711161214480.24276@gandalf.stny.rr.com>  <47435B31.2070304@yahoo.fr>
 <1197690973.12832.12.camel@sx.thebigcorporation.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 14 Dec 2007, Sven-Thorsten Dietrich wrote:

> Hi Steve,
>
> looks like this patch didn't make it into 2.6.23-rc5-rt1.
>
> I refreshed Trem's final version - please review and include in the next
> RT release.
>

Sven,

Thanks,  I'll take a look at it and if I don't find any issues I'll add it
to -rt2 (or rc6-rt1 which ever comes first).

-- Steve

