Return-Path: <linux-kernel-owner+w=401wt.eu-S1760197AbZCNWGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760197AbZCNWGX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 18:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753451AbZCNWGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 18:06:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43753
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757630AbZCNWGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 18:06:08 -0400
Date: Sat, 14 Mar 2009 15:05:52 -0700 (PDT)
Message-Id: <20090314.150552.239936272.davem@davemloft.net>
To: tmb@mandriva.org
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       john.dykstra1@gmail.com
Subject: Re: [Bug #12869] BUG when disabled ipv6 module is unloaded
From: David Miller <davem@davemloft.net>
In-Reply-To: <49BC29FA.1060308@mandriva.org>
References: <MiincthRUSI.A.eKC.F4BvJB@chimera>
	<GCLaknAim2M.A.DjC.O4BvJB@chimera>
	<49BC29FA.1060308@mandriva.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Backlund <tmb@mandriva.org>
Date: Sun, 15 Mar 2009 00:04:42 +0200

> Rafael J. Wysocki skrev:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me know
> > (either way).
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12869
> > Subject		: BUG when disabled ipv6 module is unloaded
> > Submitter	: Thomas Backlund <tmb@mandriva.org>
> > Date		: 2009-03-10 20:15 (5 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123671614621097&w=4
> > Handled-By	: John Dykstra <john.dykstra1@gmail.com>
> > Patch		: http://marc.info/?l=linux-kernel&m=123672746905127&w=4
> > 
> 
> Yeah, sorry for the delay testing it...
> 
> I confirm the bug is fixed with the above patch...

Yes and that patch will be on it's way to Linus from the
net-2.6 tree shortly.
