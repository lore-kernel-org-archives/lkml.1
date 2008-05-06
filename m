Return-Path: <linux-kernel-owner+w=401wt.eu-S933882AbYEFVbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933882AbYEFVbF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 17:31:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932557AbYEFVUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 17:20:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43561 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933295AbYEFVUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 17:20:12 -0400
Date: Tue, 6 May 2008 14:18:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: tglx@linutronix.de, johnstul@us.ibm.com, ralf@linux-mips.org,
       anemo@mba.ocn.ne.jp, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clocksource: shift helper
Message-Id: <20080506141808.900ace98.akpm@linux-foundation.org>
In-Reply-To: <1210107675.17132.181.camel@localhost.localdomain>
References: <20080501173123.444094226@mvista.com>
	<alpine.LFD.1.10.0805060250410.3318@apollo.tec.linutronix.de>
	<1210091954.17132.142.camel@localhost.localdomain>
	<alpine.LFD.1.10.0805061854310.3318@apollo.tec.linutronix.de>
	<1210106014.17132.172.camel@localhost.localdomain>
	<alpine.LFD.1.10.0805062242020.3318@apollo.tec.linutronix.de>
	<1210107675.17132.181.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 May 2008 14:01:15 -0700
Daniel Walker <dwalker@mvista.com> wrote:

> your sloppy wording "pulled from the MIPS tree"

Let it just be said: the amount of time which is lost due to poor patch
descriptions exceeds the amount of time which was saved in not
bothering to write good patch descriptions.

That it all.

