Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733AbYGALWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbYGALWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 07:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbYGALWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 07:22:41 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:51119 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbYGALWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 07:22:40 -0400
Date: Tue, 1 Jul 2008 13:22:31 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: 2.6.26-rc1 regression since 2.6.25 - problem in 2.6.26-rc8
	again
Message-ID: <20080701112231.GA5111@ics.muni.cz>
References: <20080630122626.GB4413@ics.muni.cz> <Pine.LNX.4.44L0.0806301318570.2138-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.44L0.0806301318570.2138-100000@iolanthe.rowland.org>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 147.251.3.109
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 01 Jul 2008 13:22:33 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 01:21:00PM -0400, Alan Stern wrote:
> Ah, good.  I see the problem now.
> 
> To tell the truth, this has been fixed in the development tree for so 
> long that I had forgotten about it.  Unfortunately those fixes won't 
> get into the regular kernel until 2.6.27.  Until then we need another 
> fix.
> 
> The patch below should take care of the problem.  Let me know how it 
> works.

seems to be OK. Please push..

-- 
Luká¹ Hejtmánek
