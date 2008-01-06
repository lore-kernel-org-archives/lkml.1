Return-Path: <linux-kernel-owner+w=401wt.eu-S1757644AbYAFO2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644AbYAFO2Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754793AbYAFO2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:28:04 -0500
Received: from mfe1.polimi.it ([131.175.12.23]:53824 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752951AbYAFO2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:28:03 -0500
Date: Sun, 6 Jan 2008 15:24:17 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: 2.6.24-rc6-git12: Reported regressions from 2.6.23
Message-ID: <20080106152417.5cb3d186@morte>
In-Reply-To: <20080106093853.GD26291@elte.hu>
References: <200801052042.56042.rjw@sisk.pl>
	<20080106093853.GD26291@elte.hu>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.3.310218, Antispam-Engine: 2.5.2.311128, Antispam-Data: 2007.11.6.30824
X-PerlMx-Spam: No virus found, Gauge=II, Probability=22%, Report='RELAY_IN_PBL_11 2.5, BODY_SIZE_900_999 0, RDNS_GENERIC_POOLED 0, RDNS_SUSP 0, RDNS_SUSP_GENERIC 0, RELAY_IN_PBL 0, __CP_URI_IN_BODY 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jan 2008 10:38:53 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > Subject		: jiffies counter leaps in 2.6.24-rc3
> > Submitter	: Stefano Brivio <stefano.brivio@polimi.it>
> > Date		: 2007-11-29 08:36
> > References	: http://lkml.org/lkml/2007/11/24/53
> > 		  http://bugzilla.kernel.org/show_bug.cgi?id=9475
> > Handled-By	: Ingo Molnar <mingo@elte.hu>
> > Patch		: http://lkml.org/lkml/2007/12/7/132
> 
> this holds a series of problems, we've applied everything we wanted to 
> 2.6.24 already we'll do the full stack of fixes for this in 2.6.25. 
> (changing printk was deemed inappropriate so late in the -rc cycle) So 
> perhaps mark this as WILL_FIX_LATER and unmark it as a regression? 
> Stefano, do you agree?

Agreed.

> b43 works fine for you in the latest .24-rc kernel, correct?

Correct. :)


--
Ciao
Stefano
