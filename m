Return-Path: <linux-kernel-owner+w=401wt.eu-S1758454AbYBMOxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758454AbYBMOxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 09:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbYBMOxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 09:53:09 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:50703 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbYBMOxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 09:53:08 -0500
Date: Wed, 13 Feb 2008 15:53:02 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc1 regression - ondemand governor does not work at all
Message-ID: <20080213145302.GA4317@ics.muni.cz>
References: <20080213135143.GA4345@ics.muni.cz> <47B30078.50605@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47B30078.50605@gmail.com>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 147.251.54.96
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Wed, 13 Feb 2008 15:53:05 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 12:36:40PM -0200, Carlos R. Mafra wrote:
> Lukas Hejtmanek wrote:
> > Hello,
> > 
> > as of 2.6.25-rc1, ondemand governor from cpufreq (acpi-p states driver) does
> > not change frequency. Machine is still running at max frequency regardless
> > of system load.
> 
> Try the patch here:
> http://lkml.org/lkml/2008/2/12/351

it seems to be fixed by this patch.

-- 
Luká¹ Hejtmánek
