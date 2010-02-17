Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab0BQTx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 14:53:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45552 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754726Ab0BQTxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 14:53:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [Bug #15273] Regression in ptrace (Wine) starting with 2.6.33-rc1
Date: Wed, 17 Feb 2010 20:54:00 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc8-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       Michael Stefaniuc <mstefani@redhat.com>
References: <Z5cmiqDComP.A.gyF.OiIeLB@chimera> <4un6Gst5rKB.A.j0G.oiIeLB@chimera> <20100217161543.GB5041@nowhere>
In-Reply-To: <20100217161543.GB5041@nowhere>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002172054.00117.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 February 2010, Frederic Weisbecker wrote:
> On Mon, Feb 15, 2010 at 12:38:35AM +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15273
> > Subject		: Regression in ptrace (Wine) starting with 2.6.33-rc1
> > Submitter	: Michael Stefaniuc <mstefani@redhat.com>
> > Date		: 2010-02-11 16:21 (4 days old)
> 
> 
> We are taking care of it. It's actually two regressions.
> One has a fix that seems to work, and I'm working on the other one,
> trying to get that upstream before 2.6.33 gets released.
> 
> Please keep the ticket open for now.

OK, thanks for the update.

Rafael
