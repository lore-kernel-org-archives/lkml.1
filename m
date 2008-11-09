Return-Path: <linux-kernel-owner+w=401wt.eu-S1755688AbYKIPOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688AbYKIPOR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 10:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754987AbYKIPOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 10:14:04 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:43388 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755200AbYKIPOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 10:14:03 -0500
Date: Sun, 9 Nov 2008 16:14:04 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Frans Pop <elendil@planet.nl>
Cc: arjan@infradead.org, rjw@sisk.pl, linux-kernel@vger.kernel.org
Subject: Re: Bootup time regression from 2.6.27 to 2.6.28-rc3+
Message-ID: <20081109151404.GF4353@ics.muni.cz>
References: <20081104173300.GF6134@ics.muni.cz> <200811090106.04579.rjw@sisk.pl> <20081108205532.7952fec6@infradead.org> <20081108205532.7952fec6@infradead.org> <20081109085649.GD4353@ics.muni.cz> <200811091520.13044.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200811091520.13044.elendil@planet.nl>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Sun, 09 Nov 2008 16:13:57 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2008 at 03:20:12PM +0100, Frans Pop wrote:
> That sounds very much like the issues described in this thread:
> http://lkml.org/lkml/2008/10/28/226

yes, looks pretty much the same but it appears on a plain libata driver.

> Do you use LUKS encryption and/or LVM?

nope. just AHCI driver & ext3 file system.

-- 
Luká¹ Hejtmánek
