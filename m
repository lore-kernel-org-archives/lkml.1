Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab0BHIGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 03:06:14 -0500
Received: from senator.holtmann.net ([87.106.208.187]:37871 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926Ab0BHIGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 03:06:03 -0500
Subject: Re: [Bug #15127] Bluetooth: sleeping function called from invalid
 context
From: Marcel Holtmann <marcel@holtmann.org>
To: davidjon@xenontk.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Luiz Augusto von Dentz <luiz.dentz@openbossa.org>
In-Reply-To: <4B6F82B7.4090501@xenontk.org>
References: <2uzMDuY-7_O.A.M1G.7X1bLB@chimera>
	 <iuJeop2ribM.A.DgH.XY1bLB@chimera>  <4B6F82B7.4090501@xenontk.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Feb 2010 09:05:01 +0100
Message-ID: <1265616301.31341.259.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.31 and 2.6.32.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15127
> > Subject		: Bluetooth: sleeping function called from invalid context
> > Submitter	: David John <davidjon@xenontk.org>
> > Date		: 2010-01-12 9:19 (27 days old)
> > First-Bad-Commit: http://git.kernel.org/git/linus/9e726b17422bade75fba94e625cd35fd1353e682
> > References	: http://marc.info/?l=linux-kernel&m=126328727021949&w=4
> > Handled-By	: Marcel Holtmann <marcel@holtmann.org>
> > Patch		: http://patchwork.kernel.org/patch/76019/
>
> The fix has not been merged yet, so please keep this open.

a set of fixes has been sent to Dave Miller for pulling on Friday.

Regards

Marcel


