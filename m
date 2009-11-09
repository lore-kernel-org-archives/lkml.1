Return-Path: <linux-kernel-owner+w=401wt.eu-S1755747AbZKIMuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747AbZKIMuB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 07:50:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755735AbZKIMuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 07:50:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51722 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732AbZKIMt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 07:49:59 -0500
Subject: Re: [PATCH -v6 08/13] tracing: add IRQENTRY_EXIT section for MIPS
From: Steven Rostedt <rostedt@goodmis.org>
To: wuzhangjin@gmail.com
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       David Daney <ddaney@caviumnetworks.com>,
       Adam Nemet <anemet@caviumnetworks.com>,
       Patrik Kluba <kpajko79@gmail.com>
In-Reply-To: <1257737468.3451.9.camel@falcon.domain.org>
References: <cover.1256569489.git.wuzhangjin@gmail.com>
	 <f746f813531a16bd650f9290787c66cbc0cdc34d.1256569489.git.wuzhangjin@gmail.com>
	 <20091109022640.GC13153@nowhere>
	 <1257737468.3451.9.camel@falcon.domain.org>
Content-Type: text/plain
Date: Mon, 09 Nov 2009 07:48:21 -0500
Message-Id: <1257770901.2845.5.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-09 at 11:31 +0800, Wu Zhangjin wrote:

> Who should I resend this patchset to? you or Steven? If this patchset
> are okay, I will rebase it on the latest tracing/core branch of -tip and
> send the latest version out, and hope you can apply it, otherwise, I
> need to rebase it to the future mainline versions again and again ;) and
> at least, I have tested all of them and their combinations on YeeLoong
> netbook, they work well. of course, more testing report from the other
> MIPS developers are welcome ;)

Oh, and yes, just base it with tracing/core. We should be able to handle
the conflicts then.

Thanks,

-- Steve


