Return-Path: <linux-kernel-owner+w=401wt.eu-S1757653AbYAVFwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653AbYAVFwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 00:52:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbYAVFwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 00:52:00 -0500
Received: from mail.gmx.net ([213.165.64.20]:41476 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753293AbYAVFv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 00:51:59 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+bONB5oFSbtO6Sg/rmeKGpsz2Ap8zwKFuT6Whlpr
	ueTh5WLhsJ87Ez
Subject: Re: 2.6.24 regression: pan hanging unkilleable and un-straceable
From: Mike Galbraith <efault@gmx.de>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Frederik Himpe <fhimpe@telenet.be>, linux-kernel@vger.kernel.org
In-Reply-To: <200801221625.58615.nickpiggin@yahoo.com.au>
References: <1200949086.6648.19.camel@Anastacia>
	 <200801221105.11413.nickpiggin@yahoo.com.au>
	 <1200978207.3944.8.camel@homer.simson.net>
	 <200801221625.58615.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Tue, 22 Jan 2008 06:47:08 +0100
Message-Id: <1200980828.4643.11.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-22 at 16:25 +1100, Nick Piggin wrote:
> On Tuesday 22 January 2008 16:03, Mike Galbraith wrote:

> > I've hit same twice recently (not pan, and not repeatable).
> 
> Nasty. The attached patch is something really simple that can sometimes help.
> sysrq+p is also an option, if you're on a UP system.

SMP (P4/HT imitating real cores)

> Any luck getting traces?

We'll see.  Armed.

	-Mike

