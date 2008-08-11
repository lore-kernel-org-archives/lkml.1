Return-Path: <linux-kernel-owner+w=401wt.eu-S1753966AbYHKD1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbYHKD1I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 23:27:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754905AbYHKD0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 23:26:53 -0400
Received: from venus.billgatliff.com ([209.251.101.201]:43678 "EHLO
	venus.billgatliff.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912AbYHKD0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 23:26:53 -0400
Message-ID: <489FB177.2010104@billgatliff.com>
Date: Sun, 10 Aug 2008 22:26:47 -0500
From: Bill Gatliff <bgat@billgatliff.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bug #11204] Commit 76a2a6ee8a0660a29127f05989ac59ae1ce865fa
 breaks PXA270 (at least)?
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik> <cX_-nNkxKaF.A.z-C.cEjnIB@albercik> <20080810083052.GB6607@flint.arm.linux.org.uk>
In-Reply-To: <20080810083052.GB6607@flint.arm.linux.org.uk>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:
> On Sun, Aug 10, 2008 at 12:43:50AM +0200, Rafael J. Wysocki wrote:
>> The following bug entry is on the current list of known regressions
>> from 2.6.26.  Please verify if it still should be listed and let me know
>> (either way).
> 
> Well, in theory we're waiting for Bill Gatliff to do some testing
> last Monday/Tuesday of the proposed fix.
> 
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11204
>> Subject		: Commit 76a2a6ee8a0660a29127f05989ac59ae1ce865fa breaks PXA270 (at least)?
>> Submitter	: Russell King - ARM Linux <linux@arm.linux.org.uk>
>> Date		: 2008-07-29 22:31 (12 days old)
>> References	: http://marc.info/?l=linux-kernel&m=121737075314966&w=4
>> Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> Patch		: http://marc.info/?l=linux-kernel&m=121754090926333&w=4

The fix as defined by above works for me.

Signed-off-by: Bill Gatliff <bgat@billgatliff.com>


b.g.
-- 
Bill Gatliff
bgat@billgatliff.com
