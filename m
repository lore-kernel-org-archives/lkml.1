Return-Path: <linux-kernel-owner+w=401wt.eu-S1756995AbXH0MOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995AbXH0MOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 08:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbXH0MNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 08:13:55 -0400
Received: from www.osadl.org ([213.239.205.134]:43073 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751306AbXH0MNy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 08:13:54 -0400
From: =?iso-8859-1?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
Organization: Linutronix
To: Andreas Schwab <schwab@suse.de>
Subject: Re: Pausing kernel boot messages
Date: Mon, 27 Aug 2007 14:13:51 +0200
User-Agent: KMail/1.9.5
Cc: "Esteban Fernandez" <estfern@gmail.com>, linux-kernel@vger.kernel.org
References: <179e6e720708270421r5f07f9dfp434077f6a106d2d7@mail.gmail.com> <200708271353.22665.hjk@linutronix.de> <jesl6542a2.fsf@sykes.suse.de>
In-Reply-To: <jesl6542a2.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708271413.51368.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 27 August 2007 13:58 schrieb Andreas Schwab:
> Hans-Jürgen Koch <hjk@linutronix.de> writes:
> 
> > Am Montag 27 August 2007 13:21 schrieb Esteban Fernandez:
> >> How do you pause the kernel boot messages ?
> >> 
> >> ^S, Pause and Scroll lock do nothing and you can't Shift-Page-Up  after a
> >> kernel panic.
> >
> > These are functions of a shell (like bash),
> 
> Definitely not.  The shell is not a console driver, it only uses it.

Right, I wasn't precise. But it's still possible that you don't have your
keyboard available during early parts of the boot process.

Hans
