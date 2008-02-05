Return-Path: <linux-kernel-owner+w=401wt.eu-S1763049AbYBEXqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763049AbYBEXqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 18:46:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760356AbYBEXqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 18:46:23 -0500
Received: from senator.holtmann.net ([87.106.208.187]:45373 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759397AbYBEXqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 18:46:22 -0500
Subject: Re: [PATCH][v4] ipwireless: driver for 3G PC Card
From: Marcel Holtmann <marcel@holtmann.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: David Sterba <dsterba@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Ben Martel <benm@symmetric.co.nz>,
       stephen@symmetric.co.nz
In-Reply-To: <Pine.LNX.4.64.0802051114390.30955@jikos.suse.cz>
References: <20080201153707.GA24859@ds.suse.cz>
	 <Pine.LNX.4.64.0802051114390.30955@jikos.suse.cz>
Content-Type: text/plain
Date: Wed, 06 Feb 2008 00:46:52 +0100
Message-Id: <1202255212.15090.180.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

> > From: David Sterba <dsterba@suse.cz>
> > ipwireless: driver for PC Card, 3G internet connection
> 
> Linus, as there is no PCMCIA maintainer and akpm apparently wants you to 
> merge this directly [1] -- what is your position on this one please? As 
> far as I can see all the major issues that were raised during review were 
> fixed by David, so there shouldn't be any obstacles to merging it. It 
> would be nice if this driver will make it for 2.6.25 merge window.

I had some minor additional questions, but in general, I second that
this driver should be merged for 2.6.25.

The question of the PCMCIA maintainership came up on a different mailing
list. Personally I think that PCMCIA is a dead technology, but in some
industrial environments this will live longer than expected. I would
simply propose that LKML is used for PCMCIA related review and -mm for
testing.

Regards

Marcel


