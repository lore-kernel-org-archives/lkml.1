Return-Path: <linux-kernel-owner+w=401wt.eu-S1761269AbXF0PKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761269AbXF0PKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 11:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbXF0PKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 11:10:43 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:50105 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbXF0PKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 11:10:42 -0400
Subject: Re: Documentation of kernel messages (Summary)
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Rob Landley <rob@landley.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lf_kernel_messages@linux-foundation.org, mtk-manpages@gmx.net,
       jack@suse.cz, randy.dunlap@oracle.com, gregkh@suse.de, pavel@ucw.cz,
       kunai@linux-foundation.jp, tim.bird@am.sony.com, gh@us.ibm.com,
       arjan@infradead.org, sam@ravnborg.org, jengelh@computergmbh.de,
       hpa@zytor.com, joe@perches.com, auke-jan.h.kok@intel.com,
       hansendc@us.ibm.com, davem@davemloft.net, Valdis.Kletnieks@vt.edu,
       kenistoj@us.ibm.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
In-Reply-To: <200706251144.48658.rob@landley.net>
References: <1181747217.29512.9.camel@localhost.localdomain>
	 <20070613111549.db1fa4d9.akpm@linux-foundation.org>
	 <1182779321.7142.15.camel@localhost.localdomain>
	 <200706251144.48658.rob@landley.net>
Content-Type: text/plain
Organization: IBM
Date: Wed, 27 Jun 2007 17:11:19 +0200
Message-Id: <1182957079.6643.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-25 at 11:44 -0400, Rob Landley wrote:
> On Monday 25 June 2007 09:48:41 Michael Holzheu wrote:
> > Hi all,
> >
> > Any idea, how to proceed with this topic? Do you think that any of the
> > suggested solutions for documentation / translation of kernel messages
> > will have a chance to be included in the kernel?
> 
> Personally?  No to the second question, which renders the first "do it 
> yourself outside of the tree".

If that is the opinion of the majority here, fine. If there is no hard
rule on how to define printk macros, one option for us would be to
define some new s390 specific printk macros for our device drivers.
Similar to hundreds of other driver specific printk macros in the
kernel.

> Just a guess, and I don't speak for anyone else here, but I think most of us 
> are waiting to see how long it takes you to lose interest.

:-) Work is not always fun. Sometimes it is just a duty.

Michael


