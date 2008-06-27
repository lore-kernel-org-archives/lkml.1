Return-Path: <linux-kernel-owner+w=401wt.eu-S1756100AbYF0J3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbYF0J3A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 05:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbYF0J2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 05:28:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35156 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbYF0J2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 05:28:50 -0400
Subject: Re: linux-next: Tree for June 26
From: David Woodhouse <dwmw2@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       kernel-testers@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Jaswinder Singh <jaswinder@infradead.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
In-Reply-To: <200806270138.53895.rjw@sisk.pl>
References: <20080627010842.e1a0c4b5.sfr@canb.auug.org.au>
	 <200806270138.53895.rjw@sisk.pl>
Content-Type: text/plain
Date: Fri, 27 Jun 2008 10:28:43 +0100
Message-Id: <1214558923.10393.172.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-06-27 at 01:38 +0200, Rafael J. Wysocki wrote:
> Apparently, with this patch applied the tg3 has a NULL pointer
> dereference somewhere, but I can only see the first line of the oops,
> afterwards the box hangs solid.
> 
> Please drop it if possible.

I'll take a careful look over it for problems, and will drop it for now
if I can't find the cause. I did post it for review, but just got
mostly-unrelated noise rather than anyone looking at the code changes.

-- 
dwmw2

