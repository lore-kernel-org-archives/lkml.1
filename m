Return-Path: <linux-kernel-owner+w=401wt.eu-S1765958AbXGPOPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765958AbXGPOPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 10:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760744AbXGPOPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 10:15:32 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41882 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760626AbXGPOPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 10:15:32 -0400
Date: Mon, 16 Jul 2007 10:15:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Nigel Cunningham <nigel@nigel.suspend2.net>
cc: david@lang.hm, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Al Boldi <a1426z@gawab.com>
Subject: Re: Hibernation considerations
In-Reply-To: <200707160938.16037.nigel@nigel.suspend2.net>
Message-ID: <Pine.LNX.4.44L0.0707161013440.3410-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007, Nigel Cunningham wrote:

> > As I understand it, running a different OS between the hibernate and 
> > the resume would violate the ACPI spec.
> 
> Well then, I know one or two people who would argue that the ACPI spec is 
> faulty. :\

It's hard to argue against that.  In fact there are people who would 
argue that the ACPI spec is incomplete and inconsistent period, 
regardless of any questions about what happens between hibernate and 
resume.  :-)

Alan Stern

