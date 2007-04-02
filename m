Return-Path: <linux-kernel-owner+w=401wt.eu-S965748AbXDBTlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965748AbXDBTlX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 15:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965749AbXDBTlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 15:41:23 -0400
Received: from www.osadl.org ([213.239.205.134]:35432 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965748AbXDBTlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 15:41:22 -0400
Subject: Re: hrtimer_start problem?
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: jim.houston@comcast.net
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1175540469.6299.84.camel@x2.site>
References: <1175540469.6299.84.camel@x2.site>
Content-Type: text/plain
Date: Mon, 02 Apr 2007 21:41:31 +0200
Message-Id: <1175542891.28263.181.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-02 at 15:01 -0400, Jim Houston wrote:
> I ran into this with a Concurrent kernel based on your
> patch-2.6.18-hrt-dyntick2.  I have checked that the logic is
> still the same in kernel.org.

It's fixed with commit 935c631db827cc3a96df4dcc6fec374b994fdbd1

	tglx


