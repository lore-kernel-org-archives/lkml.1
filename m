Return-Path: <linux-kernel-owner+w=401wt.eu-S1758556AbXK0PH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556AbXK0PH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 10:07:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755256AbXK0PHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 10:07:15 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:41453 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447AbXK0PHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 10:07:14 -0500
Date: Tue, 27 Nov 2007 16:07:00 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: e1000 driver problems
Message-ID: <20071127150700.GB4365@ics.muni.cz>
References: <20061017205316.25914.qmail@web83109.mail.mud.yahoo.com> <45354850.6050900@intel.com> <20071120143803.GA5638@ics.muni.cz> <474B5610.4030800@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <474B5610.4030800@intel.com>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Muni-Spam-TestIP: 147.251.54.96
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 27 Nov 2007 16:07:09 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2007 at 03:26:08PM -0800, Kok, Auke wrote:
> The fix for this has been to grant more time for the hardware to recover
> from this busy state. I'll make sure to check if the upstream drivers are OK
> in this regard.
> 
> you can try our out-of-tree e1000 driver (7.6.x or newer) which should work
> OK for you with respect to this problem. Please give that a try.

unfortunately, the 7.6.9 driver cannot be compiled with 2.6.24-rc3-git2
kernel due to compilation errors.

-- 
Luká¹ Hejtmánek
