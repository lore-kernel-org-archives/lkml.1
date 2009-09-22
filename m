Return-Path: <linux-kernel-owner+w=401wt.eu-S1752605AbZIVQmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbZIVQmR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 12:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbZIVQmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 12:42:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48687 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642AbZIVQmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 12:42:16 -0400
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: Daniel Walker <dwalker@fifo99.com>, claudio@evidence.eu.com,
       michael@evidence.eu.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
In-Reply-To: <1253628061.20345.173.camel@Palantir>
References: <1253615424.20345.76.camel@Palantir>
	 <1253625878.6575.34.camel@desktop>  <1253628061.20345.173.camel@Palantir>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 18:42:01 +0200
Message-Id: <1253637721.18939.3.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 16:01 +0200, Raistlin wrote:
> On Tue, 2009-09-22 at 06:24 -0700, Daniel Walker wrote:
> > You've got some type of encoding corruption in your patch,
> > 
> Oops! Sorry about that... :(

Don't worry, they are fine.

