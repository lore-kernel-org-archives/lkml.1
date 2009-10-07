Return-Path: <linux-kernel-owner+w=401wt.eu-S1752210AbZJGCsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbZJGCsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 22:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbZJGCsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 22:48:38 -0400
Received: from gate.crashing.org ([63.228.1.57]:35173 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbZJGCsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 22:48:37 -0400
Subject: Re: Linux 2.6.32-rc3
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Dave Airlie <airlied@gmail.com>, G@mit.edu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20091007023119.GJ17883@mit.edu>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain>
	 <alpine.LFD.2.00.0910052140100.309@localhost.localdomain>
	 <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com>
	 <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
	 <1254864803.6035.25.camel@pasglop>
	 <alpine.LFD.2.01.0910061513510.3432@localhost.localdomain>
	 <21d7e9970910061822i429344amb47b0bceb552abc6@mail.gmail.com>
	 <20091007023119.GJ17883@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Oct 2009 13:45:32 +1100
Message-Id: <1254883532.6035.152.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> So the problem seems to be localized to those users/developers who are
> smart enough to use git, and dumb enough not to set
> CONFIG_LOCALVERSION_AUTO.  So big of a set this actually is, I can't
> say.  Do we have any statistics about how many bug reporters make this
> mistake?

Not -that- often but I did waste a considerable amount of
time in each case when reported that "2.6.N" had a bug that in fact was
due to somebody building some random git checkout. But yeah, I suppose I
should from now and always ask precisely what kernel was used and/or
enable CONFIG_LOCALVERSION_AUTO.

Cheers,
Ben.


