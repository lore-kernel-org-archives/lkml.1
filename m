Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbYHJIb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbYHJIb3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 04:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYHJIbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 04:31:21 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43678 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbYHJIbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 04:31:20 -0400
Date: Sun, 10 Aug 2008 09:30:53 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Bill Gatliff <bgat@billgatliff.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bug #11204] Commit 76a2a6ee8a0660a29127f05989ac59ae1ce865fa breaks PXA270 (at least)?
Message-ID: <20080810083052.GB6607@flint.arm.linux.org.uk>
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik> <cX_-nNkxKaF.A.z-C.cEjnIB@albercik>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cX_-nNkxKaF.A.z-C.cEjnIB@albercik>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2008 at 12:43:50AM +0200, Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).

Well, in theory we're waiting for Bill Gatliff to do some testing
last Monday/Tuesday of the proposed fix.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11204
> Subject		: Commit 76a2a6ee8a0660a29127f05989ac59ae1ce865fa breaks PXA270 (at least)?
> Submitter	: Russell King - ARM Linux <linux@arm.linux.org.uk>
> Date		: 2008-07-29 22:31 (12 days old)
> References	: http://marc.info/?l=linux-kernel&m=121737075314966&w=4
> Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Patch		: http://marc.info/?l=linux-kernel&m=121754090926333&w=4
