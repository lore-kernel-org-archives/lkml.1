Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbYFQJ1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbYFQJ1D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 05:27:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbYFQJ0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 05:26:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40909
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751138AbYFQJ0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 05:26:52 -0400
Date: Tue, 17 Jun 2008 02:26:52 -0700 (PDT)
Message-Id: <20080617.022652.76635616.davem@davemloft.net>
To: mingo@elte.hu
Cc: arjan@linux.intel.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       tglx@linutronix.de, linville@tuxdriver.com, davej@redhat.com,
       gregkh@suse.de
Subject: Re: Oops report for the week preceding June 16th, 2008
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080617092023.GA20621@elte.hu>
References: <4856AFDF.5080901@linux.intel.com>
	<20080617092023.GA20621@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 17 Jun 2008 11:20:23 +0200

> When distros feel the need to add large and risky patches that IMO shows 
> process failure on our part and further isolates mainline from distros 
> and from testers.

You say this to the point where you sound like a broken record.  It's
a bit tiring, and nothing positive ever comes of these rants.

And I think you massively oversimplify the situation, to top it
off.

On the wireless front, I severely doubt... in fact I know because I'm
looking at every wireless merge going into my tree, that John Linville
is not holding back new drivers submissions from the current 2.6.26
tree.  Neither is Jeff Garzik for non-wireless net drivers.

If the Fedora9 tree is based off of 2.6.25 or similar (it is), well
that's how life works.  Stuff gets backported from mainline into
whatever they are using and stuff breaks from time to time.

Did you investigate any of these facts to figure out what the specific
situation is here?  Or did some of your favorite keywords pop up Arjan's
report so that you could unleash your favorite whine?
