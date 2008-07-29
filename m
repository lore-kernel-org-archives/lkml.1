Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbYG2Cuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbYG2Cuc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbYG2CuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:50:24 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33463 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752422AbYG2CuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:50:23 -0400
Date: Mon, 28 Jul 2008 22:50:16 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: 463 kernel developers missing!
Message-ID: <20080729025016.GT9378@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jon Smirl <jonsmirl@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>,
	lkml <linux-kernel@vger.kernel.org>
References: <488DFD97.7080802@simon.arlott.org.uk> <9e4733910807281022v38d323c9sc7b63235824690f6@mail.gmail.com> <488E0BB6.7020006@simon.arlott.org.uk> <9e4733910807281119m10f9b6e3v98fc892a42476c86@mail.gmail.com> <488E1147.5040803@simon.arlott.org.uk> <9e4733910807281200m25f7f16bwa6678694bb25a61@mail.gmail.com> <20080729011526.GF28946@ZenIV.linux.org.uk> <9e4733910807281825v42f9700al420ba48aebf3d790@mail.gmail.com> <20080729013650.GG28946@ZenIV.linux.org.uk> <9e4733910807281901i1a39ce93v902dd6bd240e1a34@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e4733910807281901i1a39ce93v902dd6bd240e1a34@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 10:01:06PM -0400, Jon Smirl wrote:
> I should also point out that external information (Google) was needed
> to identify several hundred names, there was insufficient information
> in the log or kernel source. If we have to reconstruct this mapping
> ten years from now for some random lawsuit, the external information
> may not be there.

Jon,

	The reality is ten years from now, many e-mail addresses won't
be accurate anyway.  We will have to track people down by hand, if it
ever comes down to that.  The signed-off-by needs to be enough so we
can track down someone (very likely only a few set of people); via a
manual method is quite acceptable.  I don't think it is really
necessary to try force fit the signed-off-by just so we can collect
better mode.

       It should also be noted that the Developer's Certification of
Origin 1.1 has laguage that was designed to make it legal to collect
the DCO lines even in the European Union.  So what rmk is doing is
strictly speaking not necessary.

							- Ted
