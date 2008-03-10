Return-Path: <linux-kernel-owner+w=401wt.eu-S1752793AbYCJNCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbYCJNCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 09:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750802AbYCJNCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 09:02:03 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46111 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbYCJNCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 09:02:02 -0400
Message-ID: <47D531CF.1060500@firstfloor.org>
Date: Mon, 10 Mar 2008 14:04:15 +0100
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Dave Jones <davej@codemonkey.org.uk>,
       Alan Stern <stern@rowland.harvard.edu>, Adam Belay <abelay@novell.com>,
       Lee Revell <rlrevell@joe-job.com>
Subject: Re: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
References: <Pine.LNX.4.44L0.0803031804330.8280-100000@iolanthe.rowland.org>	<20080303231033.GB15255@one.firstfloor.org>	<20080304040048.GA31562@codemonkey.org.uk>	<20080304071423.0e6b71c1@mjolnir.drzeus.cx>	<20080304181924.70aaf8c1@mjolnir.drzeus.cx>	<924EFEDD5F540B4284297C4DC59F3DEEA77031@orsmsx423.amr.corp.intel.com>	<20080305070201.0d16cd40@mjolnir.drzeus.cx>	<20080305094023.6486ebdf@mjolnir.drzeus.cx>	<20080306092730.4412d085@mjolnir.drzeus.cx>	<20080309151659.63d54f38@mjolnir.drzeus.cx>	<20080310100008.GA9520@elf.ucw.cz> <20080310134915.45ae7446@mjolnir.drzeus.cx>
In-Reply-To: <20080310134915.45ae7446@mjolnir.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I guess the only way to find out is to disassemble the DSDT. Exposing myself to such concentrations of ACPI is not an appealing project. :/

Normally such things are not visible in the DSDT, but hidden in SMM traps.

-Andi

