Return-Path: <linux-kernel-owner+w=401wt.eu-S1758523AbZAVNfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523AbZAVNfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 08:35:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755085AbZAVNf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 08:35:26 -0500
Received: from twin.jikos.cz ([213.151.79.26]:45849 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754244AbZAVNfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 08:35:25 -0500
Date: Thu, 22 Jan 2009 14:34:46 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: "Andrew S. Johnson" <andy@asjohnson.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12426] TMDC Joystick no longer works in kernel 2.6.28
In-Reply-To: <200901201848.32080.andy@asjohnson.com>
Message-ID: <alpine.LRH.1.10.0901221432320.13438@twin.jikos.cz>
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera> <cX2gZ6Cy9nC.A.1iB.fJRdJB@chimera> <200901201848.32080.andy@asjohnson.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2009, Andrew S. Johnson wrote:

> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12426
> > Subject		: TMDC Joystick no longer works in kernel 2.6.28
> > Submitter	: Andrew S. Johnson <andy@asjohnson.com>
> > Date		: 2009-01-10 21:53 (10 days old)
> > References	:
> > http://marc.info/?l=linux-kernel&m=123162486415366&w=4
> I have installed kernel 2.6.28.1, and this still does not work.

What exactly doesn't work? Namely:

- do you see jsX node appearing in /dev after you modprobe joydev 
  manually?
- do you see the corresponding entry for the gameport in 
  /sys/bus/gameport/{devices,drivers} ?

-- 
Jiri Kosina
SUSE Labs

