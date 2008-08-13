Return-Path: <linux-kernel-owner+w=401wt.eu-S1756587AbYHMQmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbYHMQmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 12:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbYHMQmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 12:42:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36474 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752588AbYHMQmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 12:42:38 -0400
Date: Wed, 13 Aug 2008 17:24:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       andi@firstfloor.org, riel@redhat.com, greg@kroah.com, tytso@mit.edu,
       viro@ZenIV.linux.org.uk, arjan@infradead.org, peterz@infradead.org,
       hch@infradead.org
Subject: Re: TALPA - a threat model?  well sorta.
Message-ID: <20080813172437.3ed90b0d@lxorguk.ukuu.org.uk>
In-Reply-To: <1218645375.3540.71.camel@localhost.localdomain>
References: <1218645375.3540.71.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So, what is it that anti-malware companies do?  They scan files.  That's
> it. 

Good so lets instead have a discussion about making the file event
notification more scalable. That is the same thing I want for content
indexing. It is the same thing you want for certain kinds of smart
archiving, for on-line asynchronous backup and other stuff.

It ought to be a simple clean syscall interface.

Alan
