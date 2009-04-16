Return-Path: <linux-kernel-owner+w=401wt.eu-S1756970AbZDPNzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970AbZDPNzy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 09:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbZDPNzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 09:55:44 -0400
Received: from vena.lwn.net ([206.168.112.25]:59750 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160AbZDPNzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 09:55:43 -0400
Date: Thu, 16 Apr 2009 07:55:41 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
Message-ID: <20090416075541.527b8f85@bike.lwn.net>
In-Reply-To: <200904161130.28129.rusty@rustcorp.com.au>
References: <200904140159.n3E1x1K1014705@hera.kernel.org>
	<alpine.LFD.2.00.0904151013260.4132@localhost.localdomain>
	<49E62BD5.6090508@zytor.com>
	<200904161130.28129.rusty@rustcorp.com.au>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Apr 2009 11:30:26 +0930
Rusty Russell <rusty@rustcorp.com.au> wrote:

> Anyone want to try to write a guide on writing good commit messages?

I've tried to do that about halfway through
Documentation/development-process/5.Posting.  No doubt it can be
improved...patches (with good commit messages) welcome :)

jon
