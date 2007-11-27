Return-Path: <linux-kernel-owner+w=401wt.eu-S1758775AbXK0RcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775AbXK0RcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 12:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757741AbXK0RcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 12:32:03 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:33369 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757516AbXK0RcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 12:32:01 -0500
Date: Tue, 27 Nov 2007 18:31:46 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: e1000 driver problems
Message-ID: <20071127173146.GG4365@ics.muni.cz>
References: <20061017205316.25914.qmail@web83109.mail.mud.yahoo.com> <45354850.6050900@intel.com> <20071120143803.GA5638@ics.muni.cz> <474B5610.4030800@intel.com> <20071127150700.GB4365@ics.muni.cz> <474C4A74.90705@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <474C4A74.90705@intel.com>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Muni-Spam-TestIP: 147.251.54.96
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 27 Nov 2007 18:31:56 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 08:48:52AM -0800, Kok, Auke wrote:
> > unfortunately, the 7.6.9 driver cannot be compiled with 2.6.24-rc3-git2
> > kernel due to compilation errors.
> 
> but the in-kernel version of e1000 supports the ich8 lan device just fine
> and can be builtin. also this kernel has the first release of e1000e which
> supports the ich9 onboard lan device.

I'm afraid, I'm missing the point as you have stated that in-kernel drivers
have problem with suspicious board hang...

-- 
Luká¹ Hejtmánek
