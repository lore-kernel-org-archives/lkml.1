Return-Path: <linux-kernel-owner+w=401wt.eu-S1758388AbZBYSnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388AbZBYSnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 13:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756146AbZBYSnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 13:43:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:59037 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123AbZBYSnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 13:43:40 -0500
Subject: Re: [Announce] 2.6.29-rc6-rt3
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
In-Reply-To: <1235590444.3907.5.camel@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain>
	 <alpine.LFD.2.00.0902231854360.3523@localhost.localdomain>
	 <alpine.LFD.2.00.0902241849230.3523@localhost.localdomain>
	 <alpine.LFD.2.00.0902241856480.9135@localhost.localdomain>
	 <1235590444.3907.5.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 25 Feb 2009 19:43:19 +0100
Message-Id: <1235587399.4645.3789.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-25 at 20:34 +0100, Thomas Meyer wrote:
> Am Dienstag, den 24.02.2009, 18:57 +0100 schrieb Thomas Gleixner:

> >   http://www.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.29-rc6.tar.bz2
> >   http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.29-rc6-rt3.bz2
> >   

> Should suspend&resume to ram work with this patchset applied?

If it works for you without (plain .29-rc6), then it ought to work with.

