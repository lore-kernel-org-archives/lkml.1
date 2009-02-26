Return-Path: <linux-kernel-owner+w=401wt.eu-S1754069AbZBZSrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbZBZSrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 13:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbZBZSrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 13:47:00 -0500
Received: from www17.your-server.de ([213.133.104.17]:36945 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbZBZSq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 13:46:59 -0500
Subject: Re: [Announce] 2.6.29-rc6-rt3
From: Thomas Meyer <thomas@m3y3r.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
In-Reply-To: <1235587399.4645.3789.camel@laptop>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain>
	 <alpine.LFD.2.00.0902231854360.3523@localhost.localdomain>
	 <alpine.LFD.2.00.0902241849230.3523@localhost.localdomain>
	 <alpine.LFD.2.  <1235587399.4645.3789.camel@laptop>
Content-Type: text/plain
Date: Thu, 26 Feb 2009 19:46:29 +0100
Message-Id: <1235673989.3338.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 25.02.2009, 19:43 +0100 schrieb Peter Zijlstra:
> On Wed, 2009-02-25 at 20:34 +0100, Thomas Meyer wrote:
> > Am Dienstag, den 24.02.2009, 18:57 +0100 schrieb Thomas Gleixner:
> 
> > >   http://www.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.29-rc6.tar.bz2
> > >   http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.29-rc6-rt3.bz2
> > >   
> 
> > Should suspend&resume to ram work with this patchset applied?
> 
> If it works for you without (plain .29-rc6), then it ought to work with.
> 

plain .29-rc6 suspends and resumes just fine.
but .29-rc6-rt3 suspends just fine, but never resumes.
Is there an early_dma thing for the resume path for 1394?

greets
thomas


