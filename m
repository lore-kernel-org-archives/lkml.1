Return-Path: <linux-kernel-owner+w=401wt.eu-S1754456AbZK0LDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbZK0LDN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 06:03:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754435AbZK0LDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 06:03:13 -0500
Received: from ozlabs.org ([203.10.76.45]:38464 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427AbZK0LDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 06:03:12 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH 05/10] kbuild: sort the list of symbols exported by the kernel (__ksymtab)
Date: Fri, 27 Nov 2009 21:33:15 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-15-generic; KDE/4.3.2; i686; ; )
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>, Alex Chiang <achiang@hp.com>,
       Tony Luck <tony.luck@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Mike Frysinger <vapier.adi@gmail.com>, greg@kroah.com,
       linux-kbuild@vger.kernel.org, carmelo73@gmail.com,
       linux-kernel@vger.kernel.org, kyle@mcmartin.ca, deller@gmx.de,
       jejb@parisc-linux.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, paulus@samba.org
References: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com> <4B0CF5A6.7080908@tuffmail.co.uk> <1259161737.2535.6.camel@mulgrave.site>
In-Reply-To: <1259161737.2535.6.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911272133.15617.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Nov 2009 01:38:57 am James Bottomley wrote:
> On Wed, 2009-11-25 at 09:15 +0000, Alan Jenkins wrote:
> > Yes, the series as a whole relies on that patch.  Rusty pulled the 
> > series from linux-next (thanks rusty!).
> 
> Not according to current linux-next:

Yeah, I pulled it for a day, then Alan produced the ia64 fix.

Pulling again until all acks are in...

Thanks,
Rusty.
