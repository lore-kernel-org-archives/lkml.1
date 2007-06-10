Return-Path: <linux-kernel-owner+w=401wt.eu-S1760715AbXFJDJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760715AbXFJDJh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 23:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756237AbXFJDJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 23:09:29 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55743 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751637AbXFJDJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 23:09:28 -0400
Date: Sat, 9 Jun 2007 20:08:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>
Subject: Re: Jinxed VAIO wreckage - current state of affairs
Message-Id: <20070609200827.635fec79.akpm@linux-foundation.org>
In-Reply-To: <200706092259.50694.rjw@sisk.pl>
References: <1181418873.4404.402.camel@chaos>
	<200706092259.50694.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2007 22:59:49 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Hmm, how's 2.6.22-rc4-mm2 doing on the Vaio?

People would have heard if it was busted ;)

Have seen occasional hangs in e100 resume-from-RAM, and occasional
all-black-and-dead symptoms after resume-from-RAM, but it seems to work at
least 90% of the time.
