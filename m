Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbXJIOJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbXJIOJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 10:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbXJIOJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 10:09:32 -0400
Received: from [198.99.130.12] ([198.99.130.12]:42229 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbXJIOJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 10:09:31 -0400
Date: Tue, 9 Oct 2007 10:09:06 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       kbuild devel <kbuild-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/RFT] kbuild: save ARCH & CROSS_COMPILE
Message-ID: <20071009140906.GA4942@c2.user-mode-linux.org>
References: <20071008200255.GA16497@uranus.ravnborg.org> <p73sl4k4ofq.fsf@bingen.suse.de> <20071009100030.GA22475@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071009100030.GA22475@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 12:00:30PM +0200, Sam Ravnborg wrote:
> If it is OK to drop the $(SUBARCH) assingment like this then yes.
> ARCH		?=
> CROSS_COMPILE	?=

Does the UML build still work when you do that?

				Jeff

-- 
Work email - jdike at linux dot intel dot com
