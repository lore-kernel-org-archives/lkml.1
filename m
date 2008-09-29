Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbYI2Vyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbYI2Vyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 17:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbYI2Vyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 17:54:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48124 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196AbYI2Vya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 17:54:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tino Keitel <tino.keitel@gmx.de>
Subject: Re: Wakeup from suspend via keyboard and mouse doesn't work anymore with 2.6.27-rc
Date: Mon, 29 Sep 2008 23:58:32 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <20080922202911.GA9832@dose.home.local> <200809260035.09052.rjw@sisk.pl> <20080929211904.GB3185@dose.home.local>
In-Reply-To: <20080929211904.GB3185@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809292358.32634.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 29 of September 2008, Tino Keitel wrote:
> On Fri, Sep 26, 2008 at 00:35:08 +0200, Rafael J. Wysocki wrote:
> 
> [...]
> 
> > Can you please check if the appended patch restores the previous behavior?
> 
> Yes, with this patch wakeup using the keyboard works as it did with
> 2.6.26.

Thanks for testing.

Can you also check if this patch is sufficient to fix the sky2 issue, or if you
need the patch I sent in the sky2 thread in addition to it?

Thanks,
Rafael
