Return-Path: <linux-kernel-owner+w=401wt.eu-S1757414AbYCNBd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414AbYCNBd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 21:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754264AbYCNBdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 21:33:49 -0400
Received: from saeurebad.de ([85.214.36.134]:36373 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbYCNBdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 21:33:49 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc5-git3: Reported regressions from 2.6.24
References: <200803140136.38549.rjw@sisk.pl>
Date: Fri, 14 Mar 2008 02:31:29 +0100
In-Reply-To: <200803140136.38549.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Fri, 14 Mar 2008 01:36:37 +0100")
Message-ID: <87bq5i3xce.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10164
> Subject		: ntfs build failure on no-mmu
> Submitter	: Mike Frysinger <vapier.adi@gmail.com>
> Date		: 2008-03-03 11:05 (11 days old)
> References	: http://lkml.org/lkml/2008/3/1/179

I found this: http://lkml.org/lkml/2008/3/13/6

	Hannes
