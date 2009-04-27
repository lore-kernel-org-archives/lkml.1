Return-Path: <linux-kernel-owner+w=401wt.eu-S1757333AbZD0SUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333AbZD0SUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 14:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754554AbZD0STu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 14:19:50 -0400
Received: from pearlgates.net ([82.92.180.13]:40779 "EHLO mail.pearlgates.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbZD0STt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 14:19:49 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Apr 2009 14:19:49 EDT
Date: Mon, 27 Apr 2009 20:12:29 +0200
From: Jos van der Ende <seraph@xs4all.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "DRI" <dri-devel@lists.sourceforge.net>,
       "Jos van der Ende" <seraph@xs4all.nl>
Subject: Re: [Bug #12947] r128: system hangs when X is started with DRI
 enabled
Message-Id: <20090427201229.3491928a.seraph@xs4all.nl>
In-Reply-To: <200904261943.45126.rjw@sisk.pl>
References: <tur5OtdUm3E.A.r2B.7oE9JB@chimera>
	<egHshlwQQFE.A.ITD.zpE9JB@chimera>
	<20090426170729.3489b482.angel@pearlgates.net>
	<200904261943.45126.rjw@sisk.pl>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Apr 2009 19:43:44 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Sunday 26 April 2009, Angel wrote:
> > On Sun, 26 Apr 2009 11:46:26 +0200 (CEST)
> > 
> > I've tested with kernel 2.6.29.1. The problem still persists. While everything works fine with 2.6.28 or lower, starting X (both 1.3 and 1.5) with DRI enabled on a 2.6.29 kernel results in a garbled screen and unresponsive keyboard.
> 
> Thanks for the update.
> 
> Can you also test 2.6.30-rc3, please?

Sure. Still broken in exactly the same way. (Garbled screen, non-working keyboard. System can still be ssh-ed into.)


-- 
Jos van der Ende <seraph@xs4all.nl>
