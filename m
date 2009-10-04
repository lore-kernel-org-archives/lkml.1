Return-Path: <linux-kernel-owner+w=401wt.eu-S1756312AbZJDX4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312AbZJDX4m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 19:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbZJDX4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 19:56:41 -0400
Received: from mbox2.netikka.net ([213.250.81.203]:48786 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbZJDX4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 19:56:41 -0400
Message-ID: <4AC93612.2070509@mandriva.org>
Date: Mon, 05 Oct 2009 02:56:02 +0300
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090830)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Thomas Backlund <tmb@mandriva.org>
Subject: Re: [Bug #14247] ACPI Exception: AE_TIME, Returned by Handler for
 [EmbeddedControl] flooding logs
References: <9UCePxij8cB.A.VCG.-3SxKB@chimera> <Q3xT3CnoTGE.A.aRH.b4SxKB@chimera>
In-Reply-To: <Q3xT3CnoTGE.A.aRH.b4SxKB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14247
> Subject		: ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] flooding logs
> Submitter	: Thomas Backlund <tmb@mandriva.org>
> Date		: 2009-09-25 15:08 (7 days old)
> References	: http://lkml.org/lkml/2009/9/25/121
> Handled-By	: Alexey Starikovskiy <astarikovskiy@suse.de>
> Patch		: http://patchwork.kernel.org/patch/50516/
> 
> 

Patch is now upstream, commit: e12ac3d018dd8f20a075f5520209862969146fa6

--
Thomas
