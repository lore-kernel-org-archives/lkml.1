Return-Path: <linux-kernel-owner+w=401wt.eu-S1756829AbYKQMPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbYKQMPJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 07:15:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbYKQMO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 07:14:57 -0500
Received: from nfitmail.nfit.au.dk ([130.225.31.129]:27515 "EHLO
	smtp.nfit.au.dk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753131AbYKQMO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 07:14:56 -0500
X-Greylist: delayed 469 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Nov 2008 07:14:56 EST
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Eric Anholt" <eric@anholt.net>
Subject: Re: [Bug #11954] sysprof tracer ABI regression in 2.6.28rc1
References: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera>
	<Q7OAnAv0V3D.A.MbF.8AGIJB@chimera>
From: Soeren Sandmann <sandmann@daimi.au.dk>
Date: 17 Nov 2008 13:07:04 +0100
In-Reply-To: <Q7OAnAv0V3D.A.MbF.8AGIJB@chimera>
Message-ID: <ye8k5b2eetz.fsf@camel11.daimi.au.dk>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11954
> Subject		: sysprof tracer ABI regression in 2.6.28rc1
> Submitter	: Eric Anholt <eric@anholt.net>
> Date		: 2008-11-04 22:14 (13 days old)
> Handled-By	: Eric Anholt <eric@anholt.net>
> Patch		: http://bugzilla.kernel.org/attachment.cgi?id=18683&action=view

There are no ABI guarantees for the sysprof tracer at this point,
given that it is in debugfs and that there is no working userspace
code using it.



Soren
