Return-Path: <linux-kernel-owner+w=401wt.eu-S1755863AbYBOP7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbYBOP7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 10:59:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752390AbYBOP72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 10:59:28 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:57692 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210AbYBOP71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 10:59:27 -0500
Date: Fri, 15 Feb 2008 16:59:22 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Disk schedulers
Message-ID: <20080215155922.GD4269@ics.muni.cz>
References: <20080214162104.GA5347@ics.muni.cz> <Pine.LNX.4.64.0802151541370.30301@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0802151541370.30301@fbirervta.pbzchgretzou.qr>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Fri, 15 Feb 2008 16:59:24 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 03:42:58PM +0100, Jan Engelhardt wrote:
> Also consider
> - DMA (e.g. only UDMA2 selected)
> - aging disk

it's not the case.

hdparm reports udma5 is used, if it is reliable with libata.

The disk is 3 months old, kernel does not report any errors. And it has never 
been different.

-- 
Luká¹ Hejtmánek
