Return-Path: <linux-kernel-owner+w=401wt.eu-S1753451AbZGHEUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbZGHEUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 00:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbZGHEU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 00:20:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:60143 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbZGHEU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 00:20:26 -0400
Subject: Re: [GIT PULL] [PATCH 0/22] trivial fixes typo "foo foo"
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Howells <dhowells@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Randy Dunlap <randy.dunlap@oracle.com>, Tony Luck <tony.luck@intel.com>,
       benh@kernel.crashing.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       mchehab@infradead.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Greg Ungerer <gerg@snapgear.com>, Greg KH <greg@kroah.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Ingo Molnar <mingo@elte.hu>, tytso@mit.edu, sct@redhat.com,
       Gadiyar Anand <gadiyar@ti.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.0907080012350.4994@wotan.suse.de>
References: <1246975428.3613.10.camel@ht.satnam>
	 <16756.1246981440@redhat.com> <20090707091148.7bdfcdd3@jbarnes-g45>
	 <alpine.LNX.2.00.0907080012350.4994@wotan.suse.de>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 09:48:52 +0530
Message-Id: <1247026732.2437.8.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jiri,

On Wed, 2009-07-08 at 00:15 +0200, Jiri Kosina wrote:
> On Tue, 7 Jul 2009, Jesse Barnes wrote:
> 
> > What's more, these types of patchsets don't actually improve things in 
> > any real way.  
> 
> Just submitting this to trivial@kernel.org should be appropriate and 
> acceptable. But CCing 20 people + LKML on this trvially trivial stuff is 
> really overboard.
> 

I agree, in normal cases sending email to trivial@kernel.org is enough.
But this was little bit special because it was changing :

 143 files changed, 159 insertions(+), 159 deletions(-)

But I only send header(first) email to those maintainers who are
responsible for those files.

Please check new pull request, and let me know if you found some more
issues or facing any problem in pull:

[GIT PULL] V2 trivial fixes typo "foo foo"

Thanks,
--
JSR

