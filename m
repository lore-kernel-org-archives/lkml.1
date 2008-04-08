Return-Path: <linux-kernel-owner+w=401wt.eu-S1758263AbYDHPIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263AbYDHPIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 11:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755455AbYDHPIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 11:08:36 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38223 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755106AbYDHPIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 11:08:34 -0400
Message-ID: <47FB8A6D.8000304@garzik.org>
Date: Tue, 08 Apr 2008 11:08:29 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>,
       e1000-list <e1000-devel@lists.sourceforge.net>,
       linux-pci maillist <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>, Greg KH <greg@kroah.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [ANNOUNCE] e1000 to e1000e migration of PCI Express devices
References: <47F69965.7030303@intel.com> <20080408083606.GA20863@elte.hu> <47FB7F73.9020502@garzik.org>
In-Reply-To: <47FB7F73.9020502@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Multiple PCI IDs in the same driver creates all sorts of problems, 

Clearly, I meant "the same PCI ID in multiple drivers"

Sigh.  Need the morning coffee (Pepsi).

	Jeff


