Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbYKXVU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbYKXVU3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 16:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbYKXVUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 16:20:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43450 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918AbYKXVUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 16:20:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Soeren Sonnenburg <kernel@nn7.de>
Subject: Re: [Bug #11698] 2.6.27-rc7, freezes with &gt; 1 s2ram cycle
Date: Mon, 24 Nov 2008 22:19:29 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <0kQZaQnNVIL.A.BhG.FwIKJB@chimera> <V2w_GS-X2aE.A.rcH.ywIKJB@chimera> <1227560233.4881.4.camel@localhost>
In-Reply-To: <1227560233.4881.4.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811242219.29520.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 24 of November 2008, Soeren Sonnenburg wrote:
> On Sat, 2008-11-22 at 21:59 +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.26 and 2.6.27.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.26 and 2.6.27.  Please verify if it still should
> > be listed and let me know (either way).
> 
> current mainstream hangs on *every* resume (Carlos observed the same
> hangs on wakeup from s2ram but while the cause for him were the wireless
> drivers it must be something else here)...
> 
> so this bug and the bug I am having is again hidden under something
> else. one thing I noticed: The machine resumes and numlock still works
> when using an external usb keyboard. still no display and also no second
> s2ram possible :(

Well, this sounds quite serious, but I have no idea what the problem may be.

Please have a look at, though:
http://bugzilla.kernel.org/show_bug.cgi?id=12031

Thanks,
Rafael

