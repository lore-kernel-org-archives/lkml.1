Return-Path: <linux-kernel-owner+w=401wt.eu-S1758821AbYARAIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821AbYARAIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 19:08:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756458AbYARAIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 19:08:21 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56797 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756008AbYARAIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 19:08:19 -0500
Date: Fri, 18 Jan 2008 00:00:06 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, torvalds@linux-foundation.org, bunk@kernel.org,
       Dave Kleikamp <shaggy@austin.ibm.com>, Takashi Iwai <tiwai@suse.de>,
       Shaohua Li <shaohua.li@intel.com>, Jay Vosburgh <fubar@us.ibm.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: 2.6.24-rc8-git1: Reported regressions from 2.6.23
Message-ID: <20080118000006.70e4eb8e@lxorguk.ukuu.org.uk>
In-Reply-To: <20080117155809.7ebc3bb7.akpm@linux-foundation.org>
References: <200801180035.42878.rjw@sisk.pl>
	<20080117155809.7ebc3bb7.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Subject		: PATA_HPT37X embezzles two ports
> > Submitter	: "Bjoern Olausson" <lkmlist@gmail.com>
> > Date		: 2007-12-12 11:05
> > References	: http://lkml.org/lkml/2007/12/12/161
> > 		  http://bugzilla.kernel.org/show_bug.cgi?id=9551
> > Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>
> > Patch		: http://lkml.org/lkml/2007/1/4/161

I thought that had been merged. I'll chase it up tomorrow
