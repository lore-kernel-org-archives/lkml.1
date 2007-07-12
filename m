Return-Path: <linux-kernel-owner+w=401wt.eu-S1755892AbXGLFOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbXGLFOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 01:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbXGLFOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 01:14:09 -0400
Received: from www.osadl.org ([213.239.205.134]:59609 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751310AbXGLFOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 01:14:07 -0400
Subject: Re: Forward port of latest RT patch (2.6.21.5-rt20) to 2.6.22
	available
From: Thomas Gleixner <tglx@linutronix.de>
To: Gregory Haskins <ghaskins@novell.com>
Cc: mingo@elte.hu, jim.houston@ccur.com, joe.korty@ccur.com,
       dwalker@mvista.com, David Bahi <DBahi@novell.com>,
       Moiz Kohari <MKohari@novell.com>, Sven Dietrich <SDietrich@novell.com>,
       dsaxena@plexity.net, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <469544710200005A000275CC@mcclure.wal.novell.com>
References: <469544710200005A000275CC@mcclure.wal.novell.com>
Content-Type: text/plain
Date: Thu, 12 Jul 2007 07:14:03 +0200
Message-Id: <1184217243.12353.205.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-11 at 20:58 -0400, Gregory Haskins wrote:
> 	Note also that we find that the resulting kernel does not boot on some
> T60p thinkpads without "acpi=off".  We are still investigating the root
> cause here.

Try "nohpet" for now. I'm investigating it on the -hrt side as well.

	tglx


