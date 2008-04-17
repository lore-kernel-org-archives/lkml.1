Return-Path: <linux-kernel-owner+w=401wt.eu-S1763363AbYDQJLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763363AbYDQJLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756652AbYDQJKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:10:53 -0400
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:53875 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756008AbYDQJKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:10:51 -0400
X-Greylist: delayed 552 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Apr 2008 05:10:51 EDT
Date: Thu, 17 Apr 2008 10:01:37 +0100
From: Ben Dooks <ben@fluff.org>
To: Alex Dubov <oakad@yahoo.com>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Smartmedia/xd card support - request for comments
Message-ID: <20080417090137.GB16284@fluff.org.uk>
References: <466372.69780.qm@web36702.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466372.69780.qm@web36702.mail.mud.yahoo.com>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 01:50:33AM -0700, Alex Dubov wrote:
> I've implemented, with generous help from JMicron, a native support for Smartmedia/xD picture card
> media. Currently, only JMicron backend is available, but TI expressed some interest in this too,
> so TI Flashmedia backend may soon follow.
> 
> Smartmedia cards are quite akin to the dumb flash chips, but they have their quirks that put them
> aside as a separate media type.

They're NAND chips, just with a standard ECC/block replacement
stratergy... why isn't this under drivers/mtd ?

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
