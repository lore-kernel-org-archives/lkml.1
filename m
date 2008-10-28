Return-Path: <linux-kernel-owner+w=401wt.eu-S1753065AbYJ1EXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065AbYJ1EXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 00:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbYJ1EX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 00:23:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:53448 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbYJ1EX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 00:23:27 -0400
Date: Mon, 27 Oct 2008 21:23:40 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Snitzer <snitzer@gmail.com>,
       Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH][RFC] trace: profile likely and unlikely annotations
Message-ID: <20081027212340.4776a6eb@infradead.org>
In-Reply-To: <alpine.DEB.1.10.0810272316270.802@gandalf.stny.rr.com>
References: <170fa0d20810271529g3c64ae89me29ed8b65a9c3b5e@mail.gmail.com>
	<alpine.DEB.1.10.0810271918390.19731@gandalf.stny.rr.com>
	<20081028001340.GB9797@mit.edu>
	<alpine.DEB.1.10.0810272316270.802@gandalf.stny.rr.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2008 00:12:48 -0400 (EDT)
Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Andrew Morton recently suggested having an in-kernel way to profile
> likely and unlikely macros. This patch achieves that goal.


alternatively we remove likely/unlikely ;)

or maybe only ban it from drivers or something.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
