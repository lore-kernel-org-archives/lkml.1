Return-Path: <linux-kernel-owner+w=401wt.eu-S1753778Ab0AHQEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab0AHQEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 11:04:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753711Ab0AHQEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 11:04:14 -0500
Received: from lazybastard.de ([212.112.238.170]:53166 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669Ab0AHQEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 11:04:13 -0500
Date: Fri, 8 Jan 2010 17:04:04 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mtd <linux-mtd@lists.infradead.org>, Alex Dubov <oakad@yahoo.com>
Subject: Re: RFC: [PATCH V2 0/9 Integration of SmartMedia/xD into mtd subsystem
Message-ID: <20100108160404.GE31872@logfs.org>
References: <1262963092.12577.14.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1262963092.12577.14.camel@maxim-laptop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 January 2010 17:04:52 +0200, Maxim Levitsky wrote:
> 
> * Write speed is of course still very low, but like I said, it might be
> hardware problem.

Iirc the alauda could do about 400kB/s.  Speed didn't change noticeably
between 16M and 256M cards.  My conclusion back then was to blame the
alauda chip.  If you get even less, the problem likely isn't in the
cards but in the reader and/or your driver.

> * No support for 256 byte SmartMedia in the FTL. I don't have the
> hardware to test that, and I think for now there is not much need for
> that.
> (It only applies to 1MB and 2MB SmartMedia devices anyway...)

Fair enough.  If either of the two people who still use such cards
cares... ;)

Jörn

-- 
I've never met a human being who would want to read 17,000 pages of
documentation, and if there was, I'd kill him to get him out of the
gene pool.
-- Joseph Costello
