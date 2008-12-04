Return-Path: <linux-kernel-owner+w=401wt.eu-S1757286AbYLDG7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286AbYLDG7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 01:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbYLDG7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 01:59:13 -0500
Received: from nn7.de ([85.214.94.156]:33273 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbYLDG7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 01:59:13 -0500
Subject: Re: [Bug #11698] 2.6.27-rc7, freezes with &gt; 1 s2ram cycle
From: Soeren Sonnenburg <kernel@nn7.de>
To: "Rafael J\. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <TpbYvO5GPt.A.nTF.2GyNJB@chimera>
References: <49ZBswjGjrL.A.ECE.BGyNJB@chimera>
	 <TpbYvO5GPt.A.nTF.2GyNJB@chimera>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 04 Dec 2008 07:59:08 +0100
Message-Id: <1228373948.3927.39.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-03 at 23:40 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.26 and 2.6.27.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.26 and 2.6.27.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11698
> Subject		: 2.6.27-rc7, freezes with &gt; 1 s2ram cycle
> Submitter	: Soeren Sonnenburg <kernel@nn7.de>
> Date		: 2008-09-29 11:29 (66 days old)
> References	: http://marc.info/?l=linux-kernel&m=122268780926859&w=4
> Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>

well it freezes at any s2ram resume attempt, even without X just from
console.

Soeren
