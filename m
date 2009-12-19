Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbZLSXxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbZLSXxc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 18:53:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754824AbZLSXx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 18:53:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36147 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753AbZLSXx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 18:53:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async suspend-resume patch w/ rwsems)
Date: Sun, 20 Dec 2009 00:54:30 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <alpine.LFD.2.00.0912191542570.3712@localhost.localdomain> <alpine.LFD.2.00.0912191546250.3712@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912191546250.3712@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912200054.30631.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 December 2009, Linus Torvalds wrote:
> 
> On Sat, 19 Dec 2009, Linus Torvalds wrote:
> > 
> > I suggest you try to treat the i8042 controller async, and see if it is 
> > problematic. If it isn't, don't do that then.
> 
> I obviously meant: "If it _is_ problematic, don't do that then". "Is", not 
> "isn't".

Sure, I understood that was a typo. :-)

Rafael
