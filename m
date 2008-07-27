Return-Path: <linux-kernel-owner+w=401wt.eu-S1759227AbYG0Uew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759227AbYG0Uew (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 16:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757884AbYG0Ueo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 16:34:44 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:20299 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757804AbYG0Uen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 16:34:43 -0400
X-IronPort-AV: E=Sophos;i="4.31,260,1215388800"; 
   d="scan'208";a="132279185"
From: Roland Dreier <rdreier@cisco.com>
To: David Miller <davem@davemloft.net>
Cc: alan@lxorguk.ukuu.org.uk, sfr@canb.auug.org.au, kkeil@suse.de,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] isdn: mISDN HFC PCI support depends on virt_to_bus()
References: <20080728023732.090aff83.sfr@canb.auug.org.au>
	<20080727182709.1dac0556@lxorguk.ukuu.org.uk>
	<20080727.125604.73857337.davem@davemloft.net>
X-Message-Flag: Warning: May contain useful information
Date: Sun, 27 Jul 2008 13:33:49 -0700
In-Reply-To: <20080727.125604.73857337.davem@davemloft.net> (David Miller's
	message of "Sun, 27 Jul 2008 12:56:04 -0700 (PDT)")
Message-ID: <adamyk35aoi.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 27 Jul 2008 20:33:51.0140 (UTC) FILETIME=[14623E40:01C8F028]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > IMHO, this driver was really rushed in and that was a huge mistake.
 > If it had gone through linux-next we could have tidied all of this
 > stuff up in a less "rushed" manner.

??  This thread *is* about a build failure in linux-next.

 - R.
