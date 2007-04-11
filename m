Return-Path: <linux-kernel-owner+w=401wt.eu-S1753276AbXDKQau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbXDKQau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 12:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbXDKQau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 12:30:50 -0400
Received: from main.gmane.org ([80.91.229.2]:39759 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276AbXDKQat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 12:30:49 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Benny Amorsen <benny+usenet@amorsen.dk>
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
Date: 11 Apr 2007 18:30:39 +0200
Message-ID: <m3tzvm6fgw.fsf@ursa.amorsen.dk>
References: <1175644642.10567.31.camel@shinybook.infradead.org> <20070403221002.GA13210@cynthia.pants.nu> <1175648051.10567.61.camel@shinybook.infradead.org> <20070403.181645.68159458.davem@davemloft.net> <20070404022828.5c9b97f3@the-village.bc.nu> <Pine.LNX.4.64.0704032307001.7802@mtl.rackplans.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 10.8.185.213.dk-amb.res.sta.perspektivbredband.net
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
Cc: linuxppc-dev@ozlabs.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "GM" == Gerhard Mack <gmack@innerfire.net> writes:

GM> On Wed, 4 Apr 2007, Alan Cox wrote:
>> You don't get machines with 64 ethernet ports on add-in cards.
>> There are good reasons for the naming schemes in use.

GM> If they made them I'd build one.

Indeed, port density is disappointingly poor in modern servers. Do you
know any with more than 14 ports per U? (That's an MBX 1U server with
8 on-board and a 6-port expansion).


/Benny


