Return-Path: <linux-kernel-owner+w=401wt.eu-S1761378AbYBLRPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761378AbYBLRPE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 12:15:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758433AbYBLROw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 12:14:52 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:36682 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757897AbYBLROv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 12:14:51 -0500
Date: Tue, 12 Feb 2008 18:14:25 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: "R. J. Wysocki" <Rafal.Wysocki@fuw.edu.pl>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25-rc1 regression - suspend to ram
Message-ID: <20080212171425.GC4582@ics.muni.cz>
References: <20080211225811.GB4343@ics.muni.cz> <200802120010.55021.Rafal.Wysocki@fuw.edu.pl> <20080211232213.GB8206@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080211232213.GB8206@linux-os.sc.intel.com>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 147.251.54.96
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 12 Feb 2008 18:14:27 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 03:22:13PM -0800, Venki Pallipadi wrote:
> Just sent this patch to fix a regression in acpi processor_idle.c on another
> thread. Can you try the patch below and check whether that helps.

Yeah, it seems that it fixed suspend troubles.

-- 
Luká¹ Hejtmánek
