Return-Path: <linux-kernel-owner+w=401wt.eu-S1763167AbYHESCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763167AbYHESCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 14:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758704AbYHESCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 14:02:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:54437 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757226AbYHESCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 14:02:34 -0400
Date: Tue, 5 Aug 2008 11:02:21 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Eric Paris <eparis@redhat.com>, "Press, Jonathan" <Jonathan.Press@ca.com>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, linux-security-module@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux
 interfaceforon access scanning
Message-ID: <20080805110221.57e4b46c@infradead.org>
In-Reply-To: <20080805182944.262f20d7@lxorguk.ukuu.org.uk>
References: <1217883616.27684.19.camel@localhost.localdomain>
	<20080804223249.GA10517@kroah.com>
	<1217896374.27684.53.camel@localhost.localdomain>
	<2629CC4E1D22A64593B02C43E855530304807431@USILMS12.ca.com>
	<1217948212.27684.120.camel@localhost.localdomain>
	<2629CC4E1D22A64593B02C43E855530304807436@USILMS12.ca.com>
	<1217956796.11547.12.camel@paris.rdu.redhat.com>
	<20080805103840.1aaa64a5@infradead.org>
	<20080805182944.262f20d7@lxorguk.ukuu.org.uk>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Aug 2008 18:29:44 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > And this can be done from userland with the preload: the
> > "workaround" from the preload assumes you've already executed
> > malicious code, which is outside of your protection scope.
> > 
> > What am I missing?
> 
> Scripts

get either opened or exec'd...

(ignoring stdin-fed scripts right now.. but that's a problem regardless)

> Attempts to screen content

can you explain?

> Exec occuring after ld.so is compromised

this is post-compromise scenario; if you have enough root rights to do
that then it's game over.


