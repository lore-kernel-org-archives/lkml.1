Return-Path: <linux-kernel-owner+w=401wt.eu-S1755358AbYCKBGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbYCKBGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 21:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbYCKBGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 21:06:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58809 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbYCKBGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 21:06:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: 2.6.25-rc5: Reported regressions from 2.6.24
Date: Tue, 11 Mar 2008 02:05:32 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
References: <200803110014.52985.rjw@sisk.pl> <47D5D4E7.1060900@garzik.org>
In-Reply-To: <47D5D4E7.1060900@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803110205.32871.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 11 of March 2008, Jeff Garzik wrote:
> Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9992
> > Subject		: 2.6.24-git: kmap_atomic() WARN_ON()
> > Submitter	: Thomas Gleixner <tglx@linutronix.de>
> > Date		: 2008-02-07 00:58
> > References	: http://lkml.org/lkml/2008/2/6/451
> > 		  http://lkml.org/lkml/2007/1/14/38
> 
> Solved by b445c56815d84b9fce40707f99811bdc354458e0

Thanks, Adrian has just closed it.

> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10123
> > Subject		: No power-off / reboot with 2.6.25-rcX (up to -rc3) kernels
> > Submitter	: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > Date		:  Tue May 22 22:47:54 2007 -0400
> > References	: http://lkml.org/lkml/2008/3/10/340
> > Handled-By	: Gautham R Shenoy <ego@in.ibm.com>
> > Patch		: http://lkml.org/lkml/2008/3/10/91
> 
> FWIW, I have this same problem.

Does the patch help?
