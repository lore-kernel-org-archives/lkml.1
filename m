Return-Path: <linux-kernel-owner+w=401wt.eu-S1758714AbYBRQwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714AbYBRQwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 11:52:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbYBRQwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 11:52:32 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:47626 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbYBRQwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 11:52:31 -0500
Date: Mon, 18 Feb 2008 08:51:34 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc2: Reported regressions from 2.6.24
Message-ID: <20080218085134.4b5c762c@laptopd505.fenrus.org>
In-Reply-To: <200802181224.54731.rjw@sisk.pl>
References: <200802172304.00322.rjw@sisk.pl>
	<20080217213733.0c46a98f@laptopd505.fenrus.org>
	<200802181224.54731.rjw@sisk.pl>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2008 12:24:53 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> > 
> > question: can we please list the last known good version for each
> > entry? Since these are all regressions (right?) that information
> > ought to be available and usually helps down in narrowing causes..
> 
> Well, this usually is only obvious for the cases in which the

last-known-good SHOULD be obvious. These are regressions right? 
A regression means "version X worked, version Y does not".
If there is no version X, it's not a regression.

Knowing version X is helpful to know how far back to look.



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
