Return-Path: <linux-kernel-owner+w=401wt.eu-S1754805AbYCVQc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbYCVQc1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 12:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbYCVQcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 12:32:20 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:53454 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbYCVQcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 12:32:19 -0400
Date: Sat, 22 Mar 2008 17:32:16 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: Re: 2.6.25-rc6-git6: Reported regressions from 2.6.24
Message-ID: <20080322163216.GB6367@osiris.boeblingen.de.ibm.com>
References: <200803220259.48534.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803220259.48534.rjw@sisk.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2008 at 02:59:47AM +0100, Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10271
> Subject		: dm raid1: bitops bug
> Submitter	: Heiko Carstens <heiko.carstens@de.ibm.com>
> Date		: 2008-03-17 16:45 (5 days old)
> References	: http://lkml.org/lkml/2008/3/17/174
> Handled-By	: Alasdair G Kergon <agk@redhat.com>

For this one a patch is available in -mm. Qouted patch can be seen
via the lkml.org link above ;)
