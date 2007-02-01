Return-Path: <linux-kernel-owner+w=401wt.eu-S1161157AbXBAGAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161157AbXBAGAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 01:00:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161177AbXBAGAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 01:00:20 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35790 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161157AbXBAGAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 01:00:19 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Luigi Genoni" <luigi.genoni@pirelli.com>
Cc: <akpm@osdl.org>, <linux-kernel@vger.kernel.org>
Subject: Re: System crash after "No irq handler for vector" linux 2.6.19
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<Pine.LNX.4.64.0701232052330.32111@baldios.it.pirelli.com>
	<m1bqkfbnep.fsf@ebiederm.dsl.xmission.com>
	<200701311549.22512.luigi.genoni@pirelli.com>
Date: Wed, 31 Jan 2007 22:59:46 -0700
In-Reply-To: <200701311549.22512.luigi.genoni@pirelli.com> (Luigi Genoni's
	message of "Wed, 31 Jan 2007 15:49:22 +0100")
Message-ID: <m1lkji8lkd.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Luigi Genoni" <luigi.genoni@pirelli.com> writes:

> OK,
> willing to test any patch.

Sure.  After I get things working on this end I will copy you,
on any fixes so you can confirm they work for you.

I am still root causing this but I have found a small fix that should
keep the system from going down when this problem occurs.

If you could confirm that it keeps your system from going down I'd
appreciate it.

Eric
