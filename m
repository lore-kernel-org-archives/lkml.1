Return-Path: <linux-kernel-owner+w=401wt.eu-S1754795AbZCVO2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbZCVO2V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 10:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbZCVO2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 10:28:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37707 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751752AbZCVO2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 10:28:12 -0400
Date: Sun, 22 Mar 2009 14:28:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Markus <M4rkusXXL@web.de>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12872] pwc mmap always fails with EAGAIN
Message-ID: <20090322142837.2df0d93d@lxorguk.ukuu.org.uk>
In-Reply-To: <200903221337.35237.M4rkusXXL@web.de>
References: <GPBuLTara4J.A.3kH.TZTxJB@chimera>
	<l8NZ2a3iQtG.A._5H.fZTxJB@chimera>
	<200903221337.35237.M4rkusXXL@web.de>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Mar 2009 13:37:35 +0100
Markus <M4rkusXXL@web.de> wrote:

> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me 
> know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12872
> > Subject		: pwc mmap always fails with EAGAIN
> > Submitter	: Markus <M4rkusXXL@web.de>
> > Date		: 2009-03-14 16:42 (8 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123704902201378&w=4
> 
> Still valid for 2.6.29-rc8-git5.

And not really likely to change until someone with a pwc camera adds lots
of printks to the code to work out why this happens.
