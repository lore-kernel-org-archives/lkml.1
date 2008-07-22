Return-Path: <linux-kernel-owner+w=401wt.eu-S1752246AbYGVE0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbYGVE0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 00:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750899AbYGVE0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 00:26:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:40290 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbYGVE0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 00:26:31 -0400
Date: Mon, 21 Jul 2008 21:26:18 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC] schedule_timeout_range()
Message-ID: <20080721212618.42493d12@infradead.org>
In-Reply-To: <1216699922.18980.66.camel@shinybook.infradead.org>
References: <1216695757.18980.16.camel@shinybook.infradead.org>
	<1216695942.18980.19.camel@shinybook.infradead.org>
	<200807221356.29892.nickpiggin@yahoo.com.au>
	<1216699922.18980.66.camel@shinybook.infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2008 00:12:02 -0400
David Woodhouse <dwmw2@infradead.org> wrote:

> How about 'start' and 'end'? Or 'early' and 'late'? I really don't
> care too much what it's called.

or "start" and "delta" ?


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
