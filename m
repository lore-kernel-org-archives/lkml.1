Return-Path: <linux-kernel-owner+w=401wt.eu-S1754734AbYHJGAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbYHJGAf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 02:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbYHJGA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 02:00:27 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:41745 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbYHJGA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 02:00:26 -0400
Date: Sun, 10 Aug 2008 11:29:28 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [Bug #11243] Current git fails to compile (gcc 3.4.4)
Message-ID: <20080810055928.GA19796@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik> <cX_-nNkxKaF.A.anB.eDjnIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cX_-nNkxKaF.A.anB.eDjnIB@albercik>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2008 at 12:43:51AM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11243
> Subject		: Current git fails to compile (gcc 3.4.4)
> Submitter	: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> Date		: 2008-07-18 7:55 (23 days old)
> References	: http://marc.info/?l=linux-kernel&m=121636772226303&w=4
> Handled-By	: Jeremy Fitzhardinge <jeremy@goop.org>
> 

There is a fix available for it now at http://lkml.org/lkml/2008/8/8/349

Thanks,
-- 
regards,
Dhaval
