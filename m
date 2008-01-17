Return-Path: <linux-kernel-owner+w=401wt.eu-S1755100AbYAQGZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbYAQGZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 01:25:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752925AbYAQGZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 01:25:24 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38509 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752653AbYAQGZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 01:25:23 -0500
Date: Wed, 16 Jan 2008 22:24:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: echo mem > /sys/power/state
Message-Id: <20080116222445.6f7ff66e.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So I take everyone's latest and greatest product and injudiciously type the
above command.  The result five minutes later is at
http://userweb.kernel.org/~akpm/borkage.jpg.  See if you can count all the bugs.

Sorry, but I've had it with this stuff and I'm tired of fixing everyone else's
stuff.  I'm just going to ship it.  Good luck.
