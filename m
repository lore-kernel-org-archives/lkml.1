Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbZALApT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbZALApT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 19:45:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbZALApA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 19:45:00 -0500
Received: from hera.rbi.informatik.uni-frankfurt.de ([141.2.1.1]:50995 "EHLO
	hera.rbi.informatik.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751378AbZALAo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 19:44:58 -0500
X-Greylist: delayed 37300 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Jan 2009 19:44:57 EST
From: Matthias Heinz <mheinz@informatik.uni-frankfurt.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.29-rc1: Reported regressions from 2.6.28
Date: Sun, 11 Jan 2009 15:22:14 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       "Linux PM List" <linux-pm@lists.linux-foundation.org>,
       "Linux SCSI List" <linux-scsi@vger.kernel.org>
References: <XU-8icArWLM.A.UpG.8GfaJB@chimera>
In-Reply-To: <XU-8icArWLM.A.UpG.8GfaJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901111522.18056.mheinz@informatik.uni-frankfurt.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 11. Januar 2009 schrieb Rafael J. Wysocki:
> If you know of any other unresolved regressions from 2.6.28, please let me
> know either and I'll add them to the list.  Also, please let me know if any
> of the entries below are invalid.

Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12174
Subject		: No backlight control on Samsung x360

I think this is a common bug on systems with a broken(?) bios, exposing wrong 
driver names. With 2.6.27 it was at least possible to control the backlight 
over the NVID interface.
