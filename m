Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbYJZK7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbYJZK7S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 06:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbYJZK7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 06:59:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53617 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128AbYJZK7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 06:59:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [Bug #11543] kernel panic: softlockup in tick_periodic() ???
Date: Sun, 26 Oct 2008 12:03:42 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Joshua Hoblitt <j_kernel@hoblitt.com>,
       Thomas Gleixner <tglx@linutronix.de>
References: <3ZqdCuOdOqB.A.EPE.fJ6AJB@chimera> <gLTYxg3cC1.A.csF.wK6AJB@chimera> <20081026071132.GB7639@localhost>
In-Reply-To: <20081026071132.GB7639@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810261203.43348.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 26 of October 2008, Cyrill Gorcunov wrote:
> [Rafael J. Wysocki - Sat, Oct 25, 2008 at 11:07:49PM +0200]
> | This message has been generated automatically as a part of a report
> | of regressions introduced between 2.6.26 and 2.6.27.
> | 
> | The following bug entry is on the current list of known regressions
> | introduced between 2.6.26 and 2.6.27.  Please verify if it still should
> | be listed and let me know (either way).
> | 
> | 
> | Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11543
> | Subject		: kernel panic: softlockup in tick_periodic() ???
> | Submitter	: Joshua Hoblitt <j_kernel@hoblitt.com>
> | Date		: 2008-09-11 16:46 (45 days old)
> | References	: http://marc.info/?l=linux-kernel&m=122117786124326&w=4
> | Handled-By	: Thomas Gleixner <tglx@linutronix.de>
> | 		  Cyrill Gorcunov <gorcunov@gmail.com>
> | 		  Ingo Molnar <mingo@elte.hu>
> | 
> | 
> 
> It's still there but with completely out of 'subject' problems.

OK, what subject will be more appropriate?

Rafael
