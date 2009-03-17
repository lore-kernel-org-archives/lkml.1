Return-Path: <linux-kernel-owner+w=401wt.eu-S1759148AbZCQAyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759148AbZCQAyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 20:54:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbZCQAxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 20:53:52 -0400
Received: from sh.osrg.net ([192.16.179.4]:38284 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbZCQAxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 20:53:51 -0400
Date: Tue, 17 Mar 2009 09:53:03 +0900
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, hias@horus.com,
       James.Bottomley@HansenPartnership.com
Subject: Re: [Bug #12612] hard lockup when interrupting cdda2wav
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <qm8_cedJGaP.A.3-G.5OCvJB@chimera>
References: <9nR7rAsBwYG.A.iEG.fOCvJB@chimera>
	<qm8_cedJGaP.A.3-G.5OCvJB@chimera>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090317095254P.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 17 Mar 2009 09:53:05 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Mar 2009 20:20:17 +0100 (CET)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.27 and 2.6.28.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12612
> Subject		: hard lockup when interrupting cdda2wav
> Submitter	: Matthias Reichl <hias@horus.com>
> Date		: 2009-01-28 16:41 (46 days old)
> References	: http://marc.info/?l=linux-kernel&m=123316111415677&w=4
> Handled-By	: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Patch		: http://marc.info/?l=linux-scsi&m=123371501613019&w=2

This still should be listed. I think that the fix (in James'
scsi-misc) will be merged to 2.6.30-rc1 then be backported.
