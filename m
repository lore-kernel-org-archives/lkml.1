Return-Path: <linux-kernel-owner+w=401wt.eu-S964999AbXA2XhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964999AbXA2XhT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 18:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965005AbXA2XhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 18:37:19 -0500
Received: from www.osadl.org ([213.239.205.134]:42824 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964999AbXA2XhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 18:37:18 -0500
Subject: Re: Linux 2.6.20-rc6 - sky2 resume breakage
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Riss <frederic.riss@gmail.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
In-Reply-To: <1170113200.21603.41.camel@funkylaptop>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
	 <1169931333.17469.125.camel@localhost.localdomain>
	 <20070129113159.7ad22e4c@freekitty>
	 <1170101430.29240.34.camel@localhost.localdomain>
	 <20070129133849.1b523226@freekitty>
	 <1170109401.29240.49.camel@localhost.localdomain>
	 <1170110318.21603.25.camel@funkylaptop>
	 <1170110732.29240.59.camel@localhost.localdomain>
	 <1170111056.21603.30.camel@funkylaptop>
	 <1170111464.29240.63.camel@localhost.localdomain>
	 <1170113200.21603.41.camel@funkylaptop>
Content-Type: text/plain; charset=utf-8
Date: Tue, 30 Jan 2007 00:37:59 +0100
Message-Id: <1170113879.29240.79.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-01-30 at 00:26 +0100, Frédéric Riss wrote:
> > Have you checked the syslog ?
> Yes of course. Nothing interesting.

Just got the same issue on one of my test boxen. Different network card
though. The interface comes up fine, but DNS is not working. ifdown/up
resolves it.

/me keeps an eye on that.

	tglx




